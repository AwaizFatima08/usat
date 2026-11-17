# Writer brief: Prep Simulator for USAT

You write original content for a HomiLabs Android app that helps Pakistani intermediate (FA/FSc/ICS/ICom/A-level) students prepare for HEC's USAT (Undergraduate Studies Admission Test, run by the Education Testing Council). The test is paper-based, four-option MCQs, no calculator. Accuracy matters more than speed: one wrong key damages a candidate's trust.

## Format
Read `docs/content-schema.md` and `content/blueprint.json` (your topics' prefix, counts and scope). Write `content/bank/<section>/<topic>.jsonl`. For a topic split across writers, use the file name and id range given in your task. Write in chunks of at most 40 questions per tool call, appending with Bash heredocs or Write, and run `python3 tool/validate.py --files <your files>` after each file until it reports 0 errors.

## Rules
- Original work only. Never copy or closely reword HEC/ETC sample papers, NTS papers, Pakistani prep books (Dogar, Ilmi, etc.), websites, or textbooks.
- British English, as used in Pakistan. Settings and names should feel Pakistani where a context is used (Ayesha, Bilal, Lahore, rupees).
- Exactly one correct option. Wrong options must be false, plausible and drawn from real mistakes. No "all/none of the above". No trick wording.
- Options of similar length and form. The correct option must not stand out: it is the longest option no more often than the others. The validator warns above 40 %; a file with that WARN is not finished. Vary the position of the correct answer evenly across A-D with no pattern.
- Plain Unicode for maths and science: x², √2, π, ½, ≤, ×, ÷, H₂O, Fe³⁺, CO₃²⁻. Never LaTeX. Never refer to a figure or diagram: describe geometry fully in words. Numbers of 1,000 or more take a comma.
- Levels about 30 % easy, 50 % medium, 20 % hard. A test question reads like the real test: concise, no hints. It should take a prepared candidate about 1 minute.
- Vary question shapes, numbers and scenarios. No near-duplicates, within or across files. Check what already exists in your topic files.
- Cover the topic's scope evenly; match the Pakistani intermediate (HSSC: FSc/ICS/ICom/FA) level for subject topics.
- Explanations teach: show the working or the rule, then say why the tempting option fails. Do not start with "The answer is".

## Facts
- Only state facts you are sure of. If unsure, write a different question.
- Avoid anything that goes out of date: no current office holders, latest rankings, populations, prices or "recent" events. GK must stay true for years.
- Pakistan Studies and history: use dates and names that standard sources agree on. Avoid disputed figures.
- Islamic Studies: respectful, mainstream, shared by all schools of thought; avoid sectarian or disputed fiqh points. Write "the Holy Prophet (PBUH)". No Arabic Quran text. Reference surah names only when certain. Quote hadith only by their well-known meaning, attributed to Bukhari or Muslim only when certain; never invent wording.
- Ethics: no religion is ranked above another.

## Numeric topics
Solve every numeric question yourself twice before writing the key, and check that exactly one option matches. For quant, maths, physics and chemistry, write a throwaway Python check in your scratch folder for computed answers and run it. Physics and chemistry: use g = 10 m/s² only if stated in the stem. Put units in the options.

## Boundaries
Only write the files in your task, plus your scratch folder. Do not edit tools, the blueprint or other topics. Do not run git. The Final reply is at most 6 lines: files, question counts, validator result, anything you are unsure about.
