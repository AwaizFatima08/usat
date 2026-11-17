#!/usr/bin/env python3
"""Builds assets/data from content/: one bank file per section, forms.json, catalog.json, lessons.json, memory.json, guide.json.

Run after any bank change. Same input gives the same 20 papers (fixed seed), so paper ids stay stable.
  python3 tool/build_content.py            needs the full bank
  python3 tool/build_content.py --partial  skips papers that cannot be filled (development only)
"""
import collections, json, random, re, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets/data"
BP = json.loads((ROOT / "content/blueprint.json").read_text())
PAPERS = BP["papers"]
PARTIAL = "--partial" in sys.argv


# These topics' stems are a bare word or pair, so the paper must say what is being asked.
INSTRUCTIONS = {
    ("verbal", "antonym"): "Choose the word most OPPOSITE in meaning to:",
    ("verbal", "synonym"): "Choose the word CLOSEST in meaning to:",
    ("verbal", "analogy"): "Choose the pair with the same relationship as:",
}


def load():
    sets, questions = {}, collections.defaultdict(list)
    for path in sorted((ROOT / "content/bank").glob("*/*.jsonl")):
        section, topic = path.parent.name, re.sub(r"-\d+$", "", path.stem)
        for line in path.read_text().splitlines():
            if not line.strip():
                continue
            row = json.loads(line)
            if row.get("type") == "set":
                sets[row["id"]] = row
            else:
                row["section"], row["topic"] = section, topic
                questions[(section, topic, row["pool"])].append(row)
    return sets, questions


def stem_text(q):
    prefix = INSTRUCTIONS.get((q["section"], q["topic"]))
    return f"{prefix}\n{q['stem']}" if prefix else q["stem"]


def deal(items, seed):
    """Splits items across papers so each gets the same spread of levels and topics. Sets stay whole."""
    rng = random.Random(seed)
    groups = collections.OrderedDict()
    for q in items:
        groups.setdefault(q.get("set") or q["id"], []).append(q)
    groups = list(groups.values())
    rng.shuffle(groups)
    groups.sort(key=lambda g: (g[0]["level"], g[0]["topic"]))
    start = rng.randrange(PAPERS)  # so the odd extra hard question does not always land on paper 1
    papers = [[] for _ in range(PAPERS)]
    for i, group in enumerate(groups):
        papers[(start + i) % PAPERS].append(group)
    for p in papers:
        rng.shuffle(p)
    return papers


def take(groups, count):
    """First `count` questions from a paper's groups; a set contributes evenly and keeps its questions in order."""
    if not groups or count == 0:
        return []
    size = len(groups[0])
    if size == 1:
        return [g[0] for g in groups[:count]]
    n = -(-count // size)
    picked = groups[:n]
    each, extra = divmod(count, len(picked))
    out = []
    for i, g in enumerate(picked):
        out += g[: each + (1 if i < extra else 0)]
    return out


def check(forms, questions):
    """Fails the build if a stream repeats a question or difficulty is lopsided. Returns the ids the papers use."""
    level = {q["id"]: q["level"] for items in questions.values() for q in items}
    used, seen = set(), collections.Counter()
    for form in forms:
        ids = [i for part in form["sections"] for i in part["items"]]
        used.update(ids)
        for i in ids:
            seen[(form["mode"], form["stream"], i)] += 1
        hard = sum(level[i] == 3 for i in ids) / len(ids)
        if not 0.10 <= hard <= 0.30:
            sys.exit(f"{form['id']}: {hard:.0%} hard questions is outside 10-30%")
    repeats = [k for k, n in seen.items() if n > 1]
    if repeats:
        sys.exit(f"{len(repeats)} questions repeat within a stream, e.g. {repeats[0]}")
    return used


def load_essays():
    out = {}
    for kind in ("argument", "narrative"):
        path = ROOT / "content/essays" / f"{kind}.jsonl"
        rows = [json.loads(l) for l in path.read_text().splitlines() if l.strip()] if path.exists() else []
        out[kind] = {pool: sorted((r for r in rows if r["pool"] == pool), key=lambda r: r["id"]) for pool in ("test", "practice")}
    return out


def main():
    sets, questions = load()
    essays = load_essays()
    sections = {s["key"]: s for s in BP["sections"]}
    dealt = {}
    for sec in BP["sections"]:
        pool = []
        for t in sec["topics"]:
            items = questions[(sec["key"], t["key"], "test")]
            pool += items
            dealt[(sec["key"], t["key"])] = deal(items, f"{sec['key']}/{t['key']}")
        dealt[sec["key"]] = deal(pool, sec["key"])  # whole-section quotas: balanced across its topics

    def section_items(section, quota, k):
        if isinstance(quota, int):
            items = take(dealt[section][k], quota)
            if len(items) < quota:
                raise ValueError(f"{section} short: {len(items)}/{quota} in paper {k + 1}")
            return items
        items = []
        for topic, want in quota.items():
            have = take(dealt[(section, topic)][k], want)
            if len(have) < want:
                raise ValueError(f"{section}/{topic} short: {len(have)}/{want} in paper {k + 1}")
            items += have
        return items

    forms, skipped = [], 0
    for mode_key, mode in BP["modes"].items():
        for stream_key, stream in mode["streams"].items():
            for k in range(PAPERS):
                slug = f"{mode_key}-{stream_key}-{k + 1:02d}" if len(mode["streams"]) > 1 else f"{mode_key}-{k + 1:02d}"
                try:
                    parts = []
                    for s in stream["sections"]:
                        items = section_items(s["section"], s["quota"], k)
                        part = {"key": s["section"], "title": sections[s["section"]]["title"], "items": [q["id"] for q in items]}
                        if s["section"] == "islamic":
                            pool = sorted(questions[("ethics", "ethics", "test")], key=lambda q: q["id"])
                            n = len(items)
                            if len(pool) < n:
                                raise ValueError("ethics short")
                            start = k * n % len(pool)
                            rotated = (pool + pool)[start : start + n]
                            part["alt"] = {"key": "ethics", "title": sections["ethics"]["title"], "items": [q["id"] for q in rotated]}
                        parts.append(part)
                except ValueError as e:
                    if not PARTIAL:
                        sys.exit(f"cannot build {slug}: {e}")
                    skipped += 1
                    continue
                ids = [i for p in parts for i in p["items"]]
                assert len(ids) == len(set(ids)) == mode["questions"], slug
                form = {"id": slug, "mode": mode_key, "stream": stream_key, "number": k + 1, "title": f"{stream['title']} Test {k + 1}", "minutes": mode["minutes"], "sections": parts}
                if "essay" in mode:
                    e = mode["essay"]
                    form["essays"] = {"minutes": e["minutes"], "argumentMarks": e["argument"]["marks"], "narrativeMarks": e["narrative"]["marks"],
                                      **{kind: [p["id"] for p in essays[kind]["test"][k * e[kind]["choices"]:(k + 1) * e[kind]["choices"]]] for kind in ("argument", "narrative")}}
                    if any(len(form["essays"][kind]) < e[kind]["choices"] for kind in ("argument", "narrative")):
                        if not PARTIAL:
                            sys.exit(f"cannot build {slug}: essay prompts short")
                        skipped += 1
                        continue
                forms.append(form)

    # Test questions no paper uses (the bank keeps a margin) become extra practice questions.
    used = check(forms, questions) if not PARTIAL else {i for f in forms for part in f["sections"] for i in part["items"]}
    used |= {i for f in forms for part in f["sections"] if "alt" in part for i in part["alt"]["items"]}
    for (sec, top, pool), items in list(questions.items()):
        if pool == "test":
            spare = [q for q in items if q["id"] not in used]
            questions[(sec, top, "test")] = [q for q in items if q["id"] in used]
            questions[(sec, top, "practice")] = questions.get((sec, top, "practice"), []) + spare
    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir(parents=True)
    for s in BP["sections"]:
        rows, used_sets = [], {}
        for t in s["topics"]:
            for pool in ("test", "practice"):
                for q in questions[(s["key"], t["key"], pool)]:
                    row = {"id": q["id"], "tp": t["key"], "pl": pool[0], "lv": q["level"], "s": stem_text(q), "o": q["options"], "a": q["answer"], "e": q["explanation"]}
                    if "set" in q:
                        row["st"] = q["set"]
                        used_sets[q["set"]] = {"t": sets[q["set"]].get("title", ""), "x": sets[q["set"]]["text"]}
                    if "table" in q:
                        row["tb"] = q["table"]
                    rows.append(row)
        (OUT / f"bank_{s['key']}.json").write_text(json.dumps({"sets": used_sets, "questions": rows}, ensure_ascii=False, separators=(",", ":")))
    lessons = [json.loads(f.read_text()) for f in sorted((ROOT / "content/lessons").glob("*/*.json"))]
    have_lesson = {(l["section"], l["topic"]) for l in lessons}
    memory = [card for f in sorted((ROOT / "content/memory").glob("*.json")) for card in json.loads(f.read_text())]
    (OUT / "essays.json").write_text(json.dumps([r for kind in essays.values() for pool in kind.values() for r in pool], ensure_ascii=False, separators=(",", ":")))
    (OUT / "lessons.json").write_text(json.dumps(lessons, ensure_ascii=False, separators=(",", ":")))
    (OUT / "memory.json").write_text(json.dumps(memory, ensure_ascii=False, separators=(",", ":")))
    catalog = {
        "sections": [{"key": s["key"], "title": s["title"], "topics": [
            {"key": t["key"], "title": t["title"], "practice": len(questions[(s["key"], t["key"], "practice")]), "lesson": (s["key"], t["key"]) in have_lesson} for t in s["topics"]
        ]} for s in BP["sections"]],
        "modes": [{"key": k, "title": m["title"], "subtitle": m["subtitle"], "minutes": m["minutes"], "questions": m["questions"],
                   "streams": [{"key": sk, "title": sv["title"]} for sk, sv in m["streams"].items()]} for k, m in BP["modes"].items()],
    }
    (OUT / "catalog.json").write_text(json.dumps(catalog, ensure_ascii=False, separators=(",", ":")))
    (OUT / "forms.json").write_text(json.dumps(forms, separators=(",", ":")))
    guide = ROOT / "content/guide.json"
    if guide.exists():
        shutil.copy(guide, OUT / "guide.json")
    size = sum(f.stat().st_size for f in OUT.iterdir())
    print(f"{len(forms)} papers built, {skipped} skipped, {sum(len(v) for v in questions.values())} questions, {len(lessons)} lessons, {len(memory)} memory cards, {size / 1e6:.1f} MB")


main()
