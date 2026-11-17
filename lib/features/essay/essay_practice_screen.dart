import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:usat_prep/app.dart';
import 'package:usat_prep/content/content_repository.dart';
import 'package:usat_prep/content/models.dart';
import 'package:usat_prep/features/essay/essay_assessment.dart';
import 'package:usat_prep/features/exam/exam_widgets.dart';
import 'package:usat_prep/ui/async_value_view.dart';
import 'package:usat_prep/ui/theme.dart';

/// Practice prompts of one essay kind.
class EssayListScreen extends ConsumerWidget {
  const EssayListScreen({required this.kind, super.key});

  final EssayKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final argument = kind == EssayKind.argument;
    return Scaffold(
      appBar: AppBar(title: Text(argument ? l10n.argumentPractice : l10n.narrativePractice)),
      body: AsyncBody(
        value: ref.watch(essaysProvider),
        data: (prompts) => ListView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          children: [
            Text(argument ? l10n.argumentPracticeIntro : l10n.narrativePracticeIntro),
            const SizedBox(height: AppSpacing.sm),
            for (final prompt in prompts.values)
              if (prompt.kind == kind && prompt.isPractice)
                Card(
                  child: ListTile(
                    title: Text(prompt.prompt, maxLines: 3, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.edit_note),
                    onTap: () => unawaited(context.push('/write/${prompt.id}')),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

/// One practice essay: an optional clock (20 minutes, half of Part II), then the self-assessment.
class EssayPracticeScreen extends ConsumerStatefulWidget {
  const EssayPracticeScreen({required this.promptId, super.key});

  final String promptId;

  @override
  ConsumerState<EssayPracticeScreen> createState() => _EssayPracticeScreenState();
}

class _EssayPracticeScreenState extends ConsumerState<EssayPracticeScreen> {
  final _controller = TextEditingController();
  Timer? _timer;
  int _seconds = 20 * 60;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds <= 1) {
        _finish();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    _timer?.cancel();
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AsyncValueView(
      value: ref.watch(essaysProvider),
      data: (prompts) {
        final prompt = prompts[widget.promptId]!;
        final marks = prompt.kind == EssayKind.argument ? 15 : 10;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.partTwo),
            actions: [if (!_done) TimerLabel(seconds: _seconds)],
          ),
          body: ListView(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            children: _done
                ? [
                    EssayAssessment(
                      prompt: prompt,
                      essay: _controller.text,
                      maxMarks: marks,
                      initialMarks: null,
                      onMarks: (_) {},
                    ),
                  ]
                : [
                    Card(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prompt.prompt, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: AppSpacing.sm),
                            Text(prompt.task),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _controller,
                      minLines: 14,
                      maxLines: null,
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: l10n.essayHint,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    Text(
                      l10n.wordCount(essayWords(_controller.text)),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton(onPressed: _finish, child: Text(l10n.finishEssay)),
                  ],
          ),
        );
      },
    );
  }
}
