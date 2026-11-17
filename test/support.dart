import 'package:usat_prep/content/content_repository.dart';
import 'package:usat_prep/content/models.dart';

Question question(
  String id, {
  String section = 'quant',
  String topic = 'ratio',
  int answer = 0,
  String? setId,
}) => Question(
  id: id,
  section: section,
  topic: topic,
  isPractice: false,
  level: 1,
  stem: 'Stem $id',
  options: const ['a', 'b', 'c', 'd'],
  answer: answer,
  explanation: 'Because.',
  setId: setId,
);

Sitting sittingOf(List<(String, List<Question>)> sections) {
  final parts = [
    for (final (key, questions) in sections)
      PaperSection(key: key, title: key, itemIds: [for (final q in questions) q.id]),
  ];
  return Sitting(
    paper: Paper(
      id: 'usat-e-01',
      mode: 'usat',
      stream: 'e',
      number: 1,
      title: 'Test 1',
      minutes: 100,
      sections: parts,
      essays: const EssayChoices(
        minutes: 40,
        argument: ['ea-t0001', 'ea-t0002', 'ea-t0003'],
        narrative: ['en-t0001', 'en-t0002', 'en-t0003'],
        argumentMarks: 15,
        narrativeMarks: 10,
      ),
    ),
    sections: parts,
    questions: [for (final (_, questions) in sections) ...questions],
    sets: const {},
  );
}
