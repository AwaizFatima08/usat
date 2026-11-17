import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:usat_prep/ads/ad_service.dart';
import 'package:usat_prep/app.dart';
import 'package:usat_prep/content/content_repository.dart';
import 'package:usat_prep/core/scoring.dart';
import 'package:usat_prep/features/exam/exam_notifier.dart';
import 'package:usat_prep/ui/async_value_view.dart';
import 'package:usat_prep/ui/theme.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({required this.attemptId, super.key});

  final String attemptId;

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  Future<void> _home() async {
    await ref.read(adServiceProvider).showReportInterstitial();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AsyncValueView(
      value: ref.watch(reviewProvider(widget.attemptId)),
      data: (exam) {
        final score = scoreSitting(exam.sitting, exam.attempt.answers);
        final marks = UsatMarks.of(score, exam.sitting, exam.attempt.essay);
        final essay = exam.attempt.essay;
        return Scaffold(
          appBar: AppBar(title: Text(exam.sitting.paper.title)),
          body: ListView(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            children: [
              _ScoreCard(score: score, marks: marks),
              const SizedBox(height: AppSpacing.md),
              if (exam.sitting.paper.essays != null && !(essay?.done ?? false)) ...[
                FilledButton.icon(
                  onPressed: () => context.pushReplacement('/essay/${widget.attemptId}'),
                  icon: const Icon(Icons.edit_note),
                  label: Text(l10n.continuePartTwo),
                ),
                const SizedBox(height: AppSpacing.sm),
              ] else if (exam.sitting.paper.essays != null && essay != null && !essay.skipped) ...[
                OutlinedButton.icon(
                  onPressed: () => unawaited(context.push('/essay-rate/${widget.attemptId}')),
                  icon: const Icon(Icons.rate_review_outlined),
                  label: Text(essay.isRated ? l10n.reviewEssays : l10n.rateEssays),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              FilledButton.icon(
                onPressed: () => unawaited(context.push('/review/${widget.attemptId}')),
                icon: const Icon(Icons.menu_book_outlined),
                label: Text(l10n.reviewAnswers),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.bySection, style: Theme.of(context).textTheme.titleMedium),
              for (final section in score.sections) _ScoreRow(section.title, section.tally),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.weakTopics, style: Theme.of(context).textTheme.titleMedium),
              _WeakTopics(score: score),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(onPressed: () => unawaited(_home()), child: Text(l10n.backHome)),
            ],
          ),
        );
      },
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.score, required this.marks});

  final TestScore score;
  final UsatMarks marks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final overall = score.overall;
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(l10n.results, style: Theme.of(context).textTheme.titleMedium),
            Text(
              marks.isComplete ? '${marks.total} / ${marks.max}' : '${marks.partOne} + ?',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            if (marks.isComplete)
              Text(
                marks.qualifies ? l10n.qualifies : l10n.belowQualifying,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: marks.qualifies ? AppColors.correct : AppColors.incorrect,
                ),
              )
            else
              Text(l10n.rateToFinish, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.partOneMarks(marks.partOne, marks.partOneMax, overall.percent)),
            if (marks.partTwoMax > 0)
              Text(
                marks.partTwo == null
                    ? l10n.partTwoUnrated(marks.partTwoMax)
                    : l10n.partTwoMarks(marks.partTwo!, marks.partTwoMax),
              ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.scoreNote(overall.total - score.skipped, score.skipped),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow(this.title, this.tally);

  final String title;
  final Tally tally;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(top: AppSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(title)),
            Text(context.l10n.scoreOutOf(tally.correct, tally.total)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(value: tally.percent / 100),
      ],
    ),
  );
}

class _WeakTopics extends ConsumerWidget {
  const _WeakTopics({required this.score});

  final TestScore score;

  static const _shown = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(catalogProvider),
    data: (catalog) => Column(
      children: [
        for (final topic in score.topics.take(_shown))
          _ScoreRow(catalog.topicTitle(topic.section, topic.topic), topic.tally),
      ],
    ),
  );
}
