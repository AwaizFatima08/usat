import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:usat_prep/app.dart';
import 'package:usat_prep/attempts/attempt.dart';
import 'package:usat_prep/attempts/attempt_repository.dart';
import 'package:usat_prep/content/content_repository.dart';
import 'package:usat_prep/content/models.dart';
import 'package:usat_prep/features/essay/essay_assessment.dart';
import 'package:usat_prep/features/exam/exam_notifier.dart';
import 'package:usat_prep/features/exam/exam_widgets.dart';
import 'package:usat_prep/ui/async_value_view.dart';
import 'package:usat_prep/ui/theme.dart';

/// Part II of a mock: 40 minutes for one argument and one narrative essay, each chosen from three.
class EssayPartScreen extends ConsumerWidget {
  const EssayPartScreen({required this.attemptId, super.key});

  final String attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncValueView(
    value: ref.watch(reviewProvider(attemptId)),
    data: (exam) => AsyncValueView(
      value: ref.watch(essaysProvider),
      data: (prompts) =>
          _EssayPart(attempt: exam.attempt, choices: exam.sitting.paper.essays!, prompts: prompts),
    ),
  );
}

class _EssayPart extends ConsumerStatefulWidget {
  const _EssayPart({required this.attempt, required this.choices, required this.prompts});

  final Attempt attempt;
  final EssayChoices choices;
  final Map<String, EssayPrompt> prompts;

  @override
  ConsumerState<_EssayPart> createState() => _EssayPartState();
}

class _EssayPartState extends ConsumerState<_EssayPart> with WidgetsBindingObserver {
  static const _saveEverySeconds = 15;

  late EssayPart _part =
      widget.attempt.essay ?? EssayPart(remainingSeconds: widget.choices.minutes * 60);
  late final _argument = TextEditingController(text: _part.argumentText);
  late final _narrative = TextEditingController(text: _part.narrativeText);
  Timer? _timer;
  var _kind = EssayKind.argument;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_part.done) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _toResults());
    } else {
      _start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _argument.dispose();
    _narrative.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (lifecycle == AppLifecycleState.paused) {
      _timer?.cancel();
      unawaited(_save());
    }
    if (lifecycle == AppLifecycleState.resumed && !_part.done) _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = _part.remainingSeconds - 1;
      if (left <= 0) {
        unawaited(_finish());
        return;
      }
      setState(() => _part = _part.copyWith(remainingSeconds: left));
      if (left % _saveEverySeconds == 0) unawaited(_save());
    });
  }

  EssayPart get _current =>
      _part.copyWith(argumentText: _argument.text, narrativeText: _narrative.text);

  Future<void> _save() async {
    final part = _current;
    await ref
        .read(attemptRepositoryProvider)
        .update(widget.attempt.id, (attempt) => attempt.copyWith(essay: part));
  }

  Future<void> _finish({bool skipped = false}) async {
    _timer?.cancel();
    _part = _current.copyWith(done: true, skipped: skipped);
    await _save();
    ref.invalidate(reviewProvider(widget.attempt.id));
    _toResults();
  }

  void _toResults() {
    if (mounted) context.pushReplacement('/results/${widget.attempt.id}');
  }

  Future<void> _confirm({required bool skip}) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(skip ? l10n.skipPartTwoTitle : l10n.finishPartTwoTitle),
        content: Text(skip ? l10n.skipPartTwoBody : l10n.finishPartTwoBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.keepWorking)),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(skip ? l10n.skipPartTwo : l10n.finishPartTwo),
          ),
        ],
      ),
    );
    if (ok ?? false) await _finish(skipped: skip);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final argument = _kind == EssayKind.argument;
    final ids = argument ? widget.choices.argument : widget.choices.narrative;
    final chosen = argument ? _part.argumentId : _part.narrativeId;
    final controller = argument ? _argument : _narrative;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_confirm(skip: false));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.partTwo),
          actions: [TimerLabel(seconds: _part.remainingSeconds)],
        ),
        body: ListView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          children: [
            Text(l10n.partTwoIntro(widget.choices.minutes)),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<EssayKind>(
              segments: [
                ButtonSegment(
                  value: EssayKind.argument,
                  label: Text(l10n.argumentEssay(widget.choices.argumentMarks)),
                ),
                ButtonSegment(
                  value: EssayKind.narrative,
                  label: Text(l10n.narrativeEssay(widget.choices.narrativeMarks)),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (kinds) => setState(() => _kind = kinds.single),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.choosePrompt, style: Theme.of(context).textTheme.titleSmall),
            RadioGroup<String>(
              groupValue: chosen,
              onChanged: (id) => setState(
                () => _part = argument
                    ? _part.copyWith(argumentId: id)
                    : _part.copyWith(narrativeId: id),
              ),
              child: Column(
                children: [
                  for (final id in ids)
                    if (widget.prompts[id] case final prompt?)
                      RadioListTile<String>(
                        contentPadding: EdgeInsetsDirectional.zero,
                        value: id,
                        title: Text(prompt.prompt),
                        subtitle: id == chosen ? Text(prompt.task) : null,
                      ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              key: ValueKey(_kind),
              controller: controller,
              enabled: chosen != null,
              minLines: 12,
              maxLines: null,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: chosen == null ? l10n.choosePromptFirst : l10n.essayHint,
              ),
              onChanged: (_) => setState(() {}),
            ),
            Text(
              l10n.wordCount(essayWords(controller.text)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => unawaited(_confirm(skip: false)),
              child: Text(l10n.finishPartTwo),
            ),
            TextButton(
              onPressed: () => unawaited(_confirm(skip: true)),
              child: Text(l10n.skipPartTwo),
            ),
          ],
        ),
      ),
    );
  }
}

/// Self-rating of both Part II essays after a mock.
class EssayRateScreen extends ConsumerWidget {
  const EssayRateScreen({required this.attemptId, super.key});

  final String attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AsyncValueView(
      value: ref.watch(reviewProvider(attemptId)),
      data: (exam) => AsyncValueView(
        value: ref.watch(essaysProvider),
        data: (prompts) {
          final part = exam.attempt.essay!;
          final choices = exam.sitting.paper.essays!;
          Future<void> save(EssayPart Function(EssayPart) change) async {
            await ref
                .read(attemptRepositoryProvider)
                .update(attemptId, (a) => a.copyWith(essay: change(a.essay!)));
            ref.invalidate(reviewProvider(attemptId));
          }

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(l10n.rateEssays),
                bottom: TabBar(
                  tabs: [
                    Tab(text: l10n.argumentEssay(choices.argumentMarks)),
                    Tab(text: l10n.narrativeEssay(choices.narrativeMarks)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  for (final (id, text, marks, initial, kind) in [
                    (
                      part.argumentId,
                      part.argumentText,
                      choices.argumentMarks,
                      part.argumentScore,
                      EssayKind.argument,
                    ),
                    (
                      part.narrativeId,
                      part.narrativeText,
                      choices.narrativeMarks,
                      part.narrativeScore,
                      EssayKind.narrative,
                    ),
                  ])
                    ListView(
                      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                      children: [
                        if (prompts[id] case final prompt?)
                          EssayAssessment(
                            prompt: prompt,
                            essay: text,
                            maxMarks: marks,
                            initialMarks: initial,
                            onMarks: (value) => unawaited(
                              save(
                                (p) => kind == EssayKind.argument
                                    ? p.copyWith(argumentScore: value)
                                    : p.copyWith(narrativeScore: value),
                              ),
                            ),
                          )
                        else ...[
                          Text(l10n.noPromptChosen),
                          const SizedBox(height: AppSpacing.sm),
                          FilledButton(
                            onPressed: () => unawaited(
                              save(
                                (p) => kind == EssayKind.argument
                                    ? p.copyWith(argumentScore: 0)
                                    : p.copyWith(narrativeScore: 0),
                              ),
                            ),
                            child: Text(l10n.saveMarks(0, marks)),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
