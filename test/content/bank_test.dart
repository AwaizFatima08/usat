import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:usat_prep/content/models.dart';

/// Checks the built assets: every paper resolves to real questions in the right pool.
void main() {
  final forms = jsonDecode(File('assets/data/forms.json').readAsStringSync()) as List<Object?>;
  final papers = [for (final form in forms) Paper.fromJson(form! as Json)];
  final questions = <String, Question>{};
  for (final file in Directory('assets/data').listSync().whereType<File>()) {
    final name = file.uri.pathSegments.last;
    if (!name.startsWith('bank_')) continue;
    final section = name.substring(5, name.length - 5);
    final json = jsonDecode(file.readAsStringSync()) as Json;
    for (final raw in json['questions']! as List<Object?>) {
      final question = Question.fromJson(raw! as Json, section);
      questions[question.id] = question;
    }
  }

  test('every paper uses test-pool questions only, each once', () {
    for (final paper in papers) {
      for (final useEthics in [false, true]) {
        final ids = [
          for (final section in paper.sectionsFor(useEthics: useEthics)) ...section.itemIds,
        ];
        expect(ids.toSet(), hasLength(ids.length), reason: paper.id);
        for (final id in ids) {
          expect(questions[id]?.isPractice, isFalse, reason: '${paper.id} $id');
        }
      }
    }
  });

  test('there are 20 papers for every mode and stream, with no repeats inside a stream', () {
    final streams = <String, List<Paper>>{};
    for (final paper in papers) {
      (streams['${paper.mode}/${paper.stream}'] ??= []).add(paper);
    }
    expect(streams, hasLength(6));
    for (final MapEntry(:key, :value) in streams.entries) {
      expect(value, hasLength(20), reason: key);
      final ids = [
        for (final paper in value)
          for (final section in paper.sections) ...section.itemIds,
      ];
      expect(ids.toSet(), hasLength(ids.length), reason: key);
    }
  });

  test('every paper follows the HEC weightages: 20 verbal, 25 quant, 30 subject', () {
    for (final paper in papers) {
      final counts = [for (final section in paper.sections) section.itemIds.length];
      expect(counts.take(2), [20, 25], reason: paper.id);
      expect(counts.skip(2).fold(0, (a, b) => a + b), 30, reason: paper.id);
    }
  });

  test('every paper offers 3 argument and 3 narrative prompts that exist', () {
    final essays = {
      for (final raw
          in jsonDecode(File('assets/data/essays.json').readAsStringSync()) as List<Object?>)
        EssayPrompt.fromJson(raw! as Json).id: EssayPrompt.fromJson(raw as Json),
    };
    for (final paper in papers) {
      final choices = paper.essays!;
      expect(choices.argument, hasLength(3), reason: paper.id);
      expect(choices.narrative, hasLength(3), reason: paper.id);
      for (final id in choices.argument) {
        expect(essays[id]?.kind, EssayKind.argument, reason: id);
      }
      for (final id in choices.narrative) {
        expect(essays[id]?.kind, EssayKind.narrative, reason: id);
      }
    }
  });

  test('every answer key points at an option', () {
    for (final question in questions.values) {
      expect(
        question.answer,
        inInclusiveRange(0, question.options.length - 1),
        reason: question.id,
      );
    }
  });
}
