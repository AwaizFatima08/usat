# Prep Simulator for USAT (HomiLabs) — project notes

Flutter Android app simulating HEC's USAT (Undergraduate Studies Admission Test, run by the Education Testing Council):
20 full mocks for each of the six categories (E, M, CS, GS, COM, A), each Part I (75 MCQs, 100 min) plus Part II
(argument + narrative essay, 40 min), scored out of 100 against the qualifying 50, every answer explained; study notes
and practice for every topic; essay practice with model answers; memory-trick cards; Guide (rules, test day, strategy,
memorisation). Package `usat_prep`, app id `com.homilabs.usat_prep` (locked after the first Play upload).
Launcher name "USAT Simulator". Built on the NTS engine (`/mnt/storage/projects/nts`) plus GRE-style lessons.

## Locations
- Code: `/mnt/storage/projects/usat` · GitHub `AwaizFatima08/usat` (PUBLIC repo: no secrets)
- Local backup: `/mnt/storage/project_backups/usat_backup` · Google Drive: Projects/usat (folder id 1JIS22UxN1Ksk_zQAz97coCtVIFJcVUjE)
- Backups: `bash scripts/backup.sh` (all three layers)
- Site: https://usat.homilabs.org (Hostinger `public_html/usat`, a checkout of the `deploy` branch), source in `website/`, `bash scripts/publish-site.sh`
- Research behind the pattern: `reports/USAT exam pattern 2026.md` (+ `research_notes/`), 17 Nov 2026.

## Exam format (HEC "Content Weightages for USAT", Aug 2022, re-issued Aug 2023, still cited Nov 2026)
Part I 75 MCQs/100 min: Verbal 20 (analogy 5, syn/ant 4, sentence completion 6, comprehension 5), Quant 25
(arithmetic 6, algebra 4, geometry 3, equations 3, statistics 3, scenario/mental 6), subject block 30 by category.
Part II 40 min: argument (1 of 3, 15 marks) + narrative (1 of 3, 10 marks). Total 100, qualifying 50. No negative
marking published (unconfirmed). Paper-based OMR, no calculator. `tool/make_blueprint.py` holds the recipes.
Re-check the live ETC weightage page before each release.

## Content
- `content/bank/<section>/<topic>.jsonl` (format `docs/content-schema.md`, quality bar `docs/writer-brief.md`).
  Seeded 17 Nov 2026 from the NTS bank (`tool/import_nts.py`, `src: nts:…`) and ECAT CS (`tool/import_ecat_cs.py`,
  `src: ecat:…`); Statistics, Economics, Accounting, Commerce and 143 quant items are new, all blind-agreed.
- Lessons `content/lessons/<section>/<topic>.json`, memory cards `content/memory/<section>.json`, essay prompts
  `content/essays/{argument,narrative}.jsonl` (format `docs/lesson-format.md`), Guide `tool/make_guide.py` → `content/guide.json`.
- `python3 tool/validate.py`, `python3 tool/build_content.py` (fixed seeds: papers stay stable; unused test items
  become practice items), `tool/blind.py` (independent answer check). `flutter test test/content` checks the papers.
- Every item is original HomiLabs work. Never copy HEC/ETC sample papers, NTS papers or prep books.
- Items for a human look: `docs/review-flags.md`.

## Ads
Ids in `config/admob.json` (app ca-app-pub-2087846699268567~8383175362; consent message "Prep Simulator for USAT
consent" published 17 Nov 2026). Banner on Home tabs only; interstitial when leaving results or a practice set,
5 minutes apart. Never during Part I, Part II, review or practice questions. Debug builds use Google test units;
`bash scripts/check-release-ad-ids.sh` before a release build.

## Gate before commit
```
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```
Heavy jobs follow `~/.claude/heavy-jobs.md`: use `jobq`, then `./gradlew --stop`. Emulator AVD: `usat_api35`.
