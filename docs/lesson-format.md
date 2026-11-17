# Lessons, memory cards and essay prompts

All three use the same body-line syntax, rendered by `lib/ui/rich_lines.dart`:

| Line | Renders as |
|---|---|
| `## Heading` | section heading |
| `- text` | bullet |
| `> text` | worked-example box; consecutive `>` lines form one box (`>` alone is a blank line in the box) |
| `! text` | amber tip / trap box |
| `\| cell \| cell` | table row; consecutive rows form one table, the first row is the header. Start with `| ` and separate cells with ` | ` |
| anything else | paragraph |

Plain Unicode for maths (x², √, π, ≤, H₂O). No LaTeX, no images, no figures, no Markdown bold/italics.

## Lessons: `content/lessons/<section>/<topic>.json`
One per blueprint topic (`content/blueprint.json`).
```json
{"section": "physics", "topic": "mechanics", "title": "Mechanics", "minutes": 12, "lines": ["...", "## ...", "- ..."]}
```
- 600-1,200 words. Open with what USAT asks on this topic, then the core ideas in order, key formulas or rules,
  2-4 worked examples (`>` boxes) in USAT style, and 2-4 traps (`!`). End with a short "Quick check" bullet list.
- HSSC level, British English, Pakistani context. Original wording; never copy textbooks or prep books.

## Memory cards: `content/memory/<section>.json`
A JSON list. 10-25 cards per section: formula sheets, mnemonics, rules, tables of facts worth learning by heart.
```json
[{"id": "physics-m01", "section": "physics", "title": "Equations of motion", "lines": ["| Equation | Use when", "| v = u + at | no distance given", "! Keep signs consistent: take one direction as positive."]}]
```
- Ids `<section>-m01`, `-m02`, ... Titles short. Each card fits one phone screen (about 4-14 lines).
- Mnemonics must be correct and memorable; say what each letter stands for.

## Essay prompts: `content/essays/<kind>.jsonl` (kind `argument` or `narrative`)
One JSON object per line:
```json
{"id": "ea-t0001", "pool": "test", "kind": "argument", "prompt": "...", "task": "...", "points": ["...", "..."], "model": "..."}
```
| Field | Rule |
|---|---|
| `id` | `ea-` argument / `en-` narrative, `t` test pool (goes into the 20 mocks, 3 per paper) or `p` practice, 4 digits |
| `prompt` | the statement, question or situation, 1-3 sentences |
| `task` | what to write, e.g. "Write an essay of about 300-400 words stating whether you agree or disagree. Support your view with reasons and examples." |
| `points` | 4-6 bullet points a strong response would cover (for self-rating) |
| `model` | an original model response, 300-400 words, paragraphs separated by a blank line (`\n\n`) |
