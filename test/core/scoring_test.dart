import 'package:flutter_test/flutter_test.dart';
import 'package:usat_prep/attempts/attempt.dart';
import 'package:usat_prep/core/scoring.dart';
import 'package:usat_prep/features/essay/essay_assessment.dart';

import '../support.dart';

void main() {
  final sitting = sittingOf([
    (
      'verbal',
      [
        question('v1', section: 'verbal', topic: 'analogy', answer: 1),
        question('v2', section: 'verbal', topic: 'analogy', answer: 2),
      ],
    ),
    ('quant', [question('q1', answer: 3), question('q2', topic: 'algebra')]),
  ]);

  test('counts right, wrong and skipped with no negative marking', () {
    final score = scoreSitting(sitting, {'v1': 1, 'v2': 0, 'q1': 3});
    expect(score.overall.correct, 2);
    expect(score.overall.total, 4);
    expect(score.overall.percent, 50);
    expect(score.skipped, 1);
  });

  test('scores each section separately', () {
    final score = scoreSitting(sitting, {'v1': 1, 'q2': 0});
    expect(score.sections[0].tally.correct, 1);
    expect(score.sections[0].skipped, 1);
    expect(score.sections[1].tally.correct, 1);
  });

  test('lists the weakest topic first', () {
    final score = scoreSitting(sitting, {'q1': 3, 'q2': 0});
    expect(score.topics.first.topic, 'analogy');
    expect(score.topics.first.tally.percent, 0);
  });

  test('an empty tally is zero percent', () {
    expect(const Tally(0, 0).percent, 0);
  });

  test('total out of 100 waits for both essays to be rated', () {
    final score = scoreSitting(sitting, {'v1': 1, 'q1': 3});
    const unrated = EssayPart(remainingSeconds: 0, done: true, argumentScore: 9);
    final waiting = UsatMarks.of(score, sitting, unrated);
    expect(waiting.isComplete, isFalse);
    expect(waiting.max, 4 + 25);
    final rated = UsatMarks.of(score, sitting, unrated.copyWith(narrativeScore: 6));
    expect(rated.total, 2 + 15);
    expect(rated.qualifies, isTrue);
  });

  test('a skipped Part II counts as zero', () {
    final score = scoreSitting(sitting, const {});
    final marks = UsatMarks.of(score, sitting, const EssayPart(remainingSeconds: 0, skipped: true));
    expect(marks.isComplete, isTrue);
    expect(marks.total, 0);
    expect(marks.qualifies, isFalse);
  });

  test('Part II survives a save and load', () {
    const part = EssayPart(
      remainingSeconds: 1200,
      argumentId: 'ea-t0002',
      argumentText: 'Yes, because...',
      narrativeScore: 7,
    );
    final back = EssayPart.fromJson(part.toJson());
    expect(back.argumentId, 'ea-t0002');
    expect(back.argumentText, 'Yes, because...');
    expect(back.narrativeScore, 7);
    expect(back.isRated, isFalse);
  });

  test('suggested essay marks scale with criteria and are capped for short essays', () {
    expect(suggestEssayMarks(criteriaMet: 6, criteria: 6, words: 350, max: 15), 15);
    expect(suggestEssayMarks(criteriaMet: 6, criteria: 6, words: 100, max: 15), 6);
    expect(suggestEssayMarks(criteriaMet: 3, criteria: 6, words: 300, max: 10), 5);
    expect(suggestEssayMarks(criteriaMet: 6, criteria: 6, words: 0, max: 10), 0);
  });
}
