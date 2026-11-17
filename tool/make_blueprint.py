#!/usr/bin/env python3
"""Writes content/blueprint.json: the topic list, per-topic targets and the USAT category patterns.

Pattern from HEC's "Content Weightages for USAT" (Aug 2022, revised 31 Aug 2023, still in use 2026):
Part I 75 MCQs in 100 minutes (Verbal 20, Quantitative 25, subject block 30 by category),
Part II 40 minutes: one argument essay (15 marks) and one narrative essay (10 marks), each chosen from 3.
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# section key, title, [(topic key, id prefix, title, test items, practice items, scope note)]
# Test targets are what the 20 papers need plus a margin; leftovers become practice items in the build.
SECTIONS = [
    ("verbal", "Verbal Reasoning", [
        ("analogy", "an", "Analogies", 100, 15, "WORD : WORD pairs; state the relationship in the explanation."),
        ("synonym", "sy", "Synonyms", 40, 15, "Word closest in meaning."),
        ("antonym", "at", "Antonyms", 40, 15, "Word most opposite in meaning."),
        ("sentence-completion", "sc", "Sentence Completion", 120, 15, "One or two blanks: vocabulary in context, grammar (tense, auxiliaries, prepositions) and logic of the sentence."),
        ("comprehension", "rc", "Reading Comprehension", 100, 18, "Sets: one original passage of 150-220 words with 5-6 questions (main idea, detail, inference, tone, vocabulary in context)."),
    ]),
    ("quant", "Quantitative Reasoning", [
        ("arithmetic", "qa", "Arithmetic", 120, 15, "Number system, fractions, percentages, ratio and proportion, averages, profit and loss, simple interest. No calculator."),
        ("algebra", "qf", "Algebra and Functions", 80, 15, "Simplification, exponents, factorisation, algebraic expressions, functions and their values, sequences."),
        ("equations", "qe", "Equations and Inequalities", 60, 15, "Linear and quadratic equations, simultaneous equations, inequalities, word problems that set up an equation."),
        ("geometry", "ge", "Geometry", 60, 15, "Angles, triangles, circles, area, perimeter, volume, described fully in words without figures."),
        ("statistics", "qs", "Statistics and Probability", 60, 15, "Mean, median, mode, range, reading a table (`table` field), simple probability and counting."),
        ("scenario", "qm", "Scenario-based and Mental Maths", 120, 15, "Everyday scenarios (shopping, travel, time, work, unit rates) and quick mental arithmetic, solvable without a calculator in about a minute."),
    ]),
    ("physics", "Physics", [
        ("mechanics", "pm", "Mechanics", 50, 10, "Vectors, kinematics, forces, circular motion, work, energy, power, fluids."),
        ("waves", "pw", "Oscillations, Waves and Sound", 30, 10, "SHM, waves, sound, Doppler effect."),
        ("heat", "ph", "Heat and Thermodynamics", 20, 10, "Kinetic theory, laws of thermodynamics."),
        ("electricity", "pe", "Electricity and Magnetism", 50, 10, "Electrostatics, current, magnetism, EM induction, AC."),
        ("optics", "po", "Optics", 20, 10, "Reflection, refraction, lenses, interference, diffraction."),
        ("modern", "pn", "Modern Physics", 30, 10, "Quantum ideas, atomic and nuclear physics, electronics."),
    ]),
    ("chemistry", "Chemistry", [
        ("basics", "cb", "Basic Concepts and Atomic Structure", 40, 10, "Mole, stoichiometry, states of matter, atomic structure."),
        ("physical", "cp", "Physical Chemistry", 50, 10, "Bonding, equilibrium, kinetics, thermochemistry, electrochemistry, solutions."),
        ("inorganic", "ci", "Inorganic Chemistry", 50, 10, "Periodic table, s/p/d block, industrial chemistry."),
        ("organic", "co", "Organic Chemistry", 60, 10, "Hydrocarbons, functional groups, reaction types, biomolecules, polymers."),
    ]),
    ("math", "Mathematics", [
        ("algebra", "ma", "Algebra", 60, 10, "Functions, quadratics, sequences, matrices, permutations, binomial theorem."),
        ("trigonometry", "mt", "Trigonometry", 40, 10, "Identities, equations, inverse functions."),
        ("calculus", "mc", "Calculus", 60, 10, "Limits, differentiation, integration, applications."),
        ("analytic-geometry", "mg", "Analytic Geometry and Vectors", 40, 10, "Lines, circles, conics, vectors."),
    ]),
    ("biology", "Biology", [
        ("cell", "bc", "Cell Biology and Biomolecules", 60, 10, "Cell structure, enzymes, biomolecules, bioenergetics."),
        ("diversity", "bd", "Diversity of Life", 70, 10, "Classification, kingdoms, plants, animals, ecology."),
        ("physiology", "bp", "Human Physiology", 90, 10, "Digestion, circulation, respiration, excretion, nervous and endocrine systems, immunity, reproduction."),
        ("genetics", "bg", "Genetics and Evolution", 60, 10, "Inheritance, DNA, biotechnology, evolution."),
    ]),
    ("computer", "Computer Science", [
        ("intro", "ic", "Computer Fundamentals", 110, 15, "Hardware, software, memory, number systems, data representation, operating systems."),
        ("networks", "iw", "Networks, Internet and Security", 50, 12, "Network types and devices, protocols, the internet and web, security and ethics."),
        ("programming", "ip", "Programming Fundamentals", 60, 15, "Language-neutral and C/C++ basics: variables, control flow, arrays, functions, tracing output."),
        ("database", "id", "Database Fundamentals", 60, 15, "Tables, keys, relationships, normalisation, basic SQL."),
    ]),
    ("stats", "Statistics", [
        ("descriptive", "sd", "Data and Central Tendency", 55, 12, "Data types, classification, frequency distributions, graphs described in words, mean, median, mode, weighted and geometric mean."),
        ("dispersion", "sp", "Dispersion and Index Numbers", 50, 12, "Range, quartiles, mean deviation, variance, standard deviation, coefficient of variation, skewness basics, index numbers."),
        ("probability", "sb", "Probability and Distributions", 55, 12, "Counting, probability laws, random variables, expectation, binomial, Poisson and normal distributions."),
        ("inference", "sr", "Sampling, Regression and Correlation", 50, 12, "Sampling and sampling distributions, estimation, hypothesis testing basics, simple regression and correlation, time series basics."),
    ]),
    ("economics", "Economics", [
        ("micro", "xm", "Demand, Supply and Consumer Behaviour", 55, 12, "Basic concepts, demand, supply, equilibrium, elasticity, utility, consumer surplus."),
        ("production", "xp", "Production, Costs and Markets", 50, 12, "Factors of production, laws of returns, costs, revenue, perfect competition, monopoly, other market forms, factor pricing."),
        ("macro", "xn", "National Income and Macroeconomics", 50, 12, "National income accounting, consumption and saving, investment, employment, inflation, business cycles, fiscal policy."),
        ("money", "xb", "Money, Banking and Trade", 55, 12, "Money and its functions, banks and the central bank, monetary policy, public finance and taxes, international trade, balance of payments, exchange rates."),
    ]),
    ("accounting", "Accounting", [
        ("basics", "ab", "Accounting Basics and Double Entry", 55, 12, "Concepts and conventions, accounting equation, debit and credit rules, source documents."),
        ("records", "aj", "Journal, Ledger and Trial Balance", 55, 12, "Journal entries, subsidiary books, ledger posting and balancing, cash book, trial balance."),
        ("final", "af", "Final Accounts and Adjustments", 50, 12, "Income statement, balance sheet, capital and revenue items, adjustments (accruals, prepayments, bad debts, depreciation)."),
        ("special", "ar", "Bank Reconciliation, Errors and Partnership", 50, 12, "Bank reconciliation, rectification of errors, suspense account, depreciation methods, partnership basics, bills of exchange."),
    ]),
    ("commerce", "Commerce", [
        ("trade", "bt", "Commerce and Trade", 55, 12, "Meaning and scope of commerce, home and foreign trade, wholesale and retail, documents of trade, aids to trade."),
        ("organisation", "bo", "Forms of Business Organisation", 55, 12, "Sole proprietorship, partnership, joint stock companies, cooperatives, public enterprises, company documents and shares."),
        ("banking", "bb", "Banking, Insurance and Transport", 50, 12, "Banks and their services, negotiable instruments, insurance principles and types, modes of transport, warehousing."),
        ("office", "bm", "Marketing, Office and Communication", 50, 12, "Marketing and advertising, stock exchange basics, office work and filing, business communication and correspondence."),
    ]),
    ("gk", "General Knowledge", [
        ("world", "gw", "World Affairs and History", 100, 12, "Stable facts only: organisations, treaties, world history, firsts."),
        ("science", "gs", "Everyday Science", 70, 12, "Inventions, human body, environment, space, technology."),
        ("geography", "gg", "World Geography", 70, 12, "Continents, oceans, capitals, currencies, landmarks."),
        ("civics", "gc", "Economy and Civics", 60, 12, "Basic economics, government, abbreviations, international bodies."),
    ]),
    ("islamic", "Islamiat", [
        ("quran", "iq", "Quran", 70, 12, "Revelation, compilation, surahs, stories of the prophets, teachings."),
        ("hadith", "ih", "Hadith and Sunnah", 40, 12, "Compilers, the major collections, well-known teachings."),
        ("beliefs", "ib", "Beliefs and Pillars", 90, 12, "Tawhid, prophethood, the hereafter, prayer, fasting, zakat, Hajj."),
        ("seerah", "is", "Seerah", 60, 12, "Life of the Holy Prophet (PBUH), key events and dates."),
        ("history", "ir", "Rightly Guided Caliphs and Islamic History", 40, 12, "The four caliphs, early battles, Muslim contributions."),
    ]),
    ("pakistan", "Pakistan Studies", [
        ("movement", "km", "Pakistan Movement", 90, 12, "1857 to 1947, leaders, resolutions, sessions, dates."),
        ("constitution", "kc", "Constitution and Government", 40, 12, "1956, 1962 and 1973 constitutions, structure of the state. Stable facts, no office holders."),
        ("geography", "kg", "Geography of Pakistan", 40, 12, "Provinces, rivers, mountains, passes, dams, neighbours."),
        ("culture", "ke", "Culture and Economy", 30, 12, "National symbols, languages, heritage sites, resources, industries."),
    ]),
    ("ethics", "Ethics", [
        ("ethics", "et", "Ethics (for non-Muslim candidates)", 150, 20, "Honesty, justice, duty, tolerance, citizenship, professional conduct, major world religions' shared moral teaching."),
    ]),
]

# Part I quotas. An explicit dict gives the exact per-paper count; an integer is split across the section's topics.
VERBAL = {"analogy": 5, "synonym": 2, "antonym": 2, "sentence-completion": 6, "comprehension": 5}
QUANT = {"arithmetic": 6, "algebra": 4, "geometry": 3, "equations": 3, "statistics": 3, "scenario": 6}
COMMON = [("verbal", VERBAL), ("quant", QUANT)]
CATEGORIES = {
    "e": ("USAT-E", "Pre-Engineering", [("physics", 10), ("chemistry", 10), ("math", 10)]),
    "m": ("USAT-M", "Pre-Medical", [("physics", 8), ("chemistry", 8), ("biology", 14)]),
    "cs": ("USAT-CS", "Computer Science", [("physics", 8), ("computer", 14), ("math", 8)]),
    "gs": ("USAT-GS", "General Science", [("math", 10), ("stats", 10), ("economics", 10)]),
    "com": ("USAT-COM", "Commerce", [("accounting", 10), ("commerce", 10), ("economics", 10)]),
    "a": ("USAT-A", "Arts and Humanities", [("islamic", 10), ("pakistan", 10), ("gk", 10)]),
}
MODES = {
    "usat": {
        "title": "USAT", "subtitle": "Undergraduate Studies Admission Test", "minutes": 100, "questions": 75,
        "essay": {"minutes": 40, "argument": {"choices": 3, "marks": 15}, "narrative": {"choices": 3, "marks": 10}},
        "pass_percent": 50,
        "streams": {k: {"title": f"{code} ({name})", "sections": COMMON + subj} for k, (code, name, subj) in CATEGORIES.items()},
    },
}
# Essay prompts: per paper, 3 argument + 3 narrative from content/essays (test pool); the rest are practice.
ESSAYS = {"argument": ("ea", 60, 15), "narrative": ("en", 60, 15)}

doc = {
    "sections": [
        {"key": k, "title": t, "topics": [
            {"key": tk, "prefix": p, "title": tt, "test": a, "practice": b, "scope": s} for tk, p, tt, a, b, s in topics
        ]} for k, t, topics in SECTIONS
    ],
    "modes": {m: {**v, "streams": {s: {"title": d["title"], "sections": [{"section": k, "quota": q} for k, q in d["sections"]]} for s, d in v["streams"].items()}} for m, v in MODES.items()},
    "essays": {k: {"prefix": p, "test": a, "practice": b} for k, (p, a, b) in ESSAYS.items()},
    "papers": 20,
}
for m in doc["modes"].values():
    for s in m["streams"].values():
        total = sum(q if isinstance(q, int) else sum(q.values()) for q in (x["quota"] for x in s["sections"]))
        assert total == m["questions"], (s["title"], total)
(ROOT / "content/blueprint.json").write_text(json.dumps(doc, indent=1) + "\n")
print("test", sum(t[3] for _, _, ts in SECTIONS for t in ts), "practice", sum(t[4] for _, _, ts in SECTIONS for t in ts))
