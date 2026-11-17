#!/usr/bin/env python3
"""One-off (17 Nov 2026): tops up computer/intro and computer/networks from the HomiLabs ECAT CS bank (our own work,
blind-checked there). Picks every 2nd item for spread; `src` keeps the ECAT id."""
import json, random
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ECAT = Path("/mnt/storage/projects/ecat/content/questions/cs")
LEVEL = {"E": 1, "M": 2, "H": 3, "D": 3}
PLAN = {"intro": (["cs-01", "cs-05"], 70, 12, "ic"), "networks": (["cs-02", "cs-03"], 35, 10, "iw")}

for topic, (units, n_test, n_practice, prefix) in PLAN.items():
    path = ROOT / "content/bank/computer" / f"{topic}.jsonl"
    have = [json.loads(l) for l in path.read_text().splitlines() if l.strip()]
    stems = {r["stem"].strip().lower() for r in have}
    pool = [q for u in units for q in json.loads((ECAT / f"{u}.json").read_text())
            if "```" not in q["q"] and q["q"].strip().lower() not in stems and len(q["o"]) == 4]
    random.Random(topic).shuffle(pool)
    count = {p: sum(r["pool"] == p for r in have) for p in ("test", "practice")}
    out = []
    for i, q in enumerate(pool[: n_test + n_practice]):
        p = "test" if i < n_test else "practice"
        count[p] += 1
        out.append({"id": f"{prefix}-{p[0]}{count[p]:04d}", "pool": p, "level": LEVEL[q["d"]], "stem": q["q"],
                    "options": q["o"], "answer": q["a"], "explanation": q["x"], "src": "ecat:" + q["id"]})
    with path.open("a") as fh:
        fh.writelines(json.dumps(r, ensure_ascii=False) + "\n" for r in out)
    print(topic, len(out))
