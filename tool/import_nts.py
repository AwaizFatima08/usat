#!/usr/bin/env python3
"""One-off (17 Nov 2026): seeds content/bank from the HomiLabs NTS bank (/mnt/storage/projects/nts), our own work.

Topics that USAT names differently are merged or split and re-numbered; `src` keeps the NTS id.
Run once on an empty bank; afterwards the USAT bank is edited directly.
"""
import json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NTS = Path("/mnt/storage/projects/nts/content/bank")
OUT = ROOT / "content/bank"
BP = json.loads((ROOT / "content/blueprint.json").read_text())
PREFIX = {(s["key"], t["key"]): t["prefix"] for s in BP["sections"] for t in s["topics"]}

SAME = ["verbal/analogy", "verbal/synonym", "verbal/antonym", "verbal/sentence-completion", "verbal/comprehension",
        "quant/geometry", "computer/programming", "computer/database", "ethics/ethics"]
SAME += [f"{s}/{p.stem}" for s in ("physics", "chemistry", "math", "biology", "gk", "islamic", "pakistan") for p in sorted((NTS / s).glob("*.jsonl"))]
NETWORK = re.compile(r"network|internet|\bweb\b|protocol|\bLAN\b|\bWAN\b|\bMAN\b|router|\bhub\b|switch|modem|e-?mail|virus|malware|firewall|phishing|encrypt|password|hacker|\bIP\b|\bURL\b|HTTP|browser|bandwidth|topology|cyber|\bDNS\b|wi-?fi|bluetooth|security", re.I)
EQUATION = re.compile(r"solve|equation|roots?\b|inequalit|satisf|solution|=.*find|find .*if", re.I)


def rows(rel):
    out = []
    for path in sorted(NTS.glob(f"{rel}*.jsonl")):
        if re.fullmatch(re.escape(Path(rel).name) + r"(-\d+)?", path.stem):
            out += [json.loads(l) for l in path.read_text().splitlines() if l.strip()]
    return out


def write(section, topic, items):
    """Re-numbers questions into the USAT topic's prefix unless they already carry it."""
    prefix = PREFIX[(section, topic)]
    n = {"test": 0, "practice": 0}
    out = []
    for r in items:
        if r.get("type") == "set":
            out.append(r)
            continue
        if not r["id"].startswith(prefix + "-"):
            n[r["pool"]] += 1
            r = {**r, "src": "nts:" + r["id"], "id": f"{prefix}-{r['pool'][0]}{n[r['pool']]:04d}"}
        else:
            r = {**r, "src": "nts:" + r["id"]}
        out.append(r)
    path = OUT / section / f"{topic}.jsonl"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(json.dumps(r, ensure_ascii=False) + "\n" for r in out))
    print(f"{section}/{topic}: {sum(1 for r in out if r.get('pool') == 'test')} test, {sum(1 for r in out if r.get('pool') == 'practice')} practice")


assert not any(OUT.glob("*/*.jsonl")), "bank is not empty"
for rel in SAME:
    s, t = rel.split("/")
    write(s, t, rows(rel))
write("quant", "arithmetic", [r for t in ("number-system", "percentage", "ratio", "average", "profit-interest") for r in rows(f"quant/{t}")])
write("quant", "statistics", rows("quant/data") + rows("quant/probability"))
write("quant", "scenario", rows("quant/speed-work"))
alg = rows("quant/algebra")
write("quant", "equations", [r for r in alg if EQUATION.search(r["stem"])])
write("quant", "algebra", [r for r in alg if not EQUATION.search(r["stem"])])
intro = rows("computer/intro")
write("computer", "networks", [r for r in intro if NETWORK.search(r["stem"] + " " + " ".join(r["options"]))])
write("computer", "intro", [r for r in intro if not NETWORK.search(r["stem"] + " " + " ".join(r["options"]))])
