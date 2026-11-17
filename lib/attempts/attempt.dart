import 'package:usat_prep/content/models.dart';

/// One sitting of a paper. Immutable; every change goes through
/// the repository as a new value.
class Attempt {
  const Attempt({
    required this.id,
    required this.paperId,
    required this.useEthics,
    required this.startedAt,
    required this.remainingSeconds,
    this.answers = const {},
    this.flagged = const {},
    this.currentIndex = 0,
    this.finishedAt,
    this.correct,
    this.total,
    this.essay,
  });

  factory Attempt.fromJson(Json json) => Attempt(
    id: json['id']! as String,
    paperId: json['paperId']! as String,
    useEthics: json['useEthics']! as bool,
    startedAt: DateTime.parse(json['startedAt']! as String),
    remainingSeconds: json['remaining']! as int,
    answers: (json['answers']! as Json).cast<String, int>(),
    flagged: (json['flagged']! as List<Object?>).cast<String>().toSet(),
    currentIndex: json['index']! as int,
    finishedAt: switch (json['finishedAt']) {
      final String value => DateTime.parse(value),
      _ => null,
    },
    correct: json['correct'] as int?,
    total: json['total'] as int?,
    essay: switch (json['essay']) {
      final Json essay => EssayPart.fromJson(essay),
      _ => null,
    },
  );

  final String id;
  final String paperId;
  final bool useEthics;
  final DateTime startedAt;
  final int remainingSeconds;

  /// Question id to chosen option.
  final Map<String, int> answers;
  final Set<String> flagged;
  final int currentIndex;
  final DateTime? finishedAt;
  final int? correct;
  final int? total;

  /// Part II, once the candidate has started it.
  final EssayPart? essay;

  bool get isFinished => finishedAt != null;

  int get percent => (total ?? 0) == 0 ? 0 : ((correct ?? 0) * 100 / total!).round();

  Attempt copyWith({
    int? remainingSeconds,
    Map<String, int>? answers,
    Set<String>? flagged,
    int? currentIndex,
    DateTime? finishedAt,
    int? correct,
    int? total,
    EssayPart? essay,
  }) => Attempt(
    id: id,
    paperId: paperId,
    useEthics: useEthics,
    startedAt: startedAt,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    answers: answers ?? this.answers,
    flagged: flagged ?? this.flagged,
    currentIndex: currentIndex ?? this.currentIndex,
    finishedAt: finishedAt ?? this.finishedAt,
    correct: correct ?? this.correct,
    total: total ?? this.total,
    essay: essay ?? this.essay,
  );

  Json toJson() => {
    'id': id,
    'paperId': paperId,
    'useEthics': useEthics,
    'startedAt': startedAt.toIso8601String(),
    'remaining': remainingSeconds,
    'answers': answers,
    'flagged': flagged.toList(),
    'index': currentIndex,
    if (finishedAt case final finished?) 'finishedAt': finished.toIso8601String(),
    'correct': ?correct,
    'total': ?total,
    if (essay case final essay?) 'essay': essay.toJson(),
  };
}

/// Part II of a sitting: the chosen prompts, what was written, the time left and the self-rated marks.
class EssayPart {
  const EssayPart({
    required this.remainingSeconds,
    this.argumentId,
    this.argumentText = '',
    this.narrativeId,
    this.narrativeText = '',
    this.done = false,
    this.skipped = false,
    this.argumentScore,
    this.narrativeScore,
  });

  factory EssayPart.fromJson(Json json) => EssayPart(
    remainingSeconds: json['remaining']! as int,
    argumentId: json['argId'] as String?,
    argumentText: json['argText'] as String? ?? '',
    narrativeId: json['narId'] as String?,
    narrativeText: json['narText'] as String? ?? '',
    done: json['done'] as bool? ?? false,
    skipped: json['skipped'] as bool? ?? false,
    argumentScore: json['argScore'] as int?,
    narrativeScore: json['narScore'] as int?,
  );

  final int remainingSeconds;
  final String? argumentId;
  final String argumentText;
  final String? narrativeId;
  final String narrativeText;
  final bool done;

  /// The candidate chose to sit Part I only.
  final bool skipped;
  final int? argumentScore;
  final int? narrativeScore;

  bool get isRated => argumentScore != null && narrativeScore != null;

  int get score => (argumentScore ?? 0) + (narrativeScore ?? 0);

  EssayPart copyWith({
    int? remainingSeconds,
    String? argumentId,
    String? argumentText,
    String? narrativeId,
    String? narrativeText,
    bool? done,
    bool? skipped,
    int? argumentScore,
    int? narrativeScore,
  }) => EssayPart(
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    argumentId: argumentId ?? this.argumentId,
    argumentText: argumentText ?? this.argumentText,
    narrativeId: narrativeId ?? this.narrativeId,
    narrativeText: narrativeText ?? this.narrativeText,
    done: done ?? this.done,
    skipped: skipped ?? this.skipped,
    argumentScore: argumentScore ?? this.argumentScore,
    narrativeScore: narrativeScore ?? this.narrativeScore,
  );

  Json toJson() => {
    'remaining': remainingSeconds,
    'argId': ?argumentId,
    'argText': argumentText,
    'narId': ?narrativeId,
    'narText': narrativeText,
    'done': done,
    'skipped': skipped,
    'argScore': ?argumentScore,
    'narScore': ?narrativeScore,
  };
}
