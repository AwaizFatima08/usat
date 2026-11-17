import 'package:flutter/material.dart';
import 'package:usat_prep/app.dart';
import 'package:usat_prep/content/models.dart';
import 'package:usat_prep/ui/theme.dart';

int essayWords(String text) => text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;

/// Suggested marks from the criteria met, capped for short essays (markers reward developed writing).
int suggestEssayMarks({
  required int criteriaMet,
  required int criteria,
  required int words,
  required int max,
}) {
  if (words == 0) return 0;
  final share = words < 120 ? 0.4 : (words < 220 ? 0.7 : 1.0);
  final raw = (max * criteriaMet / criteria).round();
  final cap = (max * share).round();
  return raw > cap ? cap : raw;
}

/// The candidate's essay beside the strong-response points and the model answer, with a self-rating
/// against plain-English criteria. No automatic marking: the candidate rates honestly.
class EssayAssessment extends StatefulWidget {
  const EssayAssessment({
    required this.prompt,
    required this.essay,
    required this.maxMarks,
    required this.initialMarks,
    required this.onMarks,
    super.key,
  });

  final EssayPrompt prompt;
  final String essay;
  final int maxMarks;
  final int? initialMarks;
  final ValueChanged<int> onMarks;

  @override
  State<EssayAssessment> createState() => _EssayAssessmentState();
}

class _EssayAssessmentState extends State<EssayAssessment> {
  final _met = <int>{};
  late int? _marks = widget.initialMarks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context).textTheme;
    final words = essayWords(widget.essay);
    final criteria = widget.prompt.kind == EssayKind.argument
        ? [
            l10n.criterionPosition,
            l10n.criterionReasons,
            l10n.criterionCounter,
            l10n.criterionOrganisation,
            l10n.criterionLanguage,
            l10n.criterionMechanics,
          ]
        : [
            l10n.criterionOpening,
            l10n.criterionSequence,
            l10n.criterionDetail,
            l10n.criterionEnding,
            l10n.criterionLanguage,
            l10n.criterionMechanics,
          ];
    final suggested = suggestEssayMarks(
      criteriaMet: _met.length,
      criteria: criteria.length,
      words: words,
      max: widget.maxMarks,
    );
    final shown = _marks ?? suggested;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.prompt.prompt, style: theme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(widget.prompt.task, style: theme.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.yourEssay, style: theme.titleMedium),
        Text(l10n.wordCount(words), style: theme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            widget.essay.trim().isEmpty ? l10n.essayEmpty : widget.essay,
            style: const TextStyle(height: 1.5),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.strongResponse, style: theme.titleMedium),
        for (final point in widget.prompt.points)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  '),
                Expanded(child: Text(point, style: const TextStyle(height: 1.4))),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        ExpansionTile(
          tilePadding: EdgeInsetsDirectional.zero,
          title: Text(l10n.modelEssay, style: theme.titleMedium),
          subtitle: Text(l10n.modelEssayNote),
          children: [SelectableText(widget.prompt.model, style: const TextStyle(height: 1.55))],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.rateYourself, style: theme.titleMedium),
        Text(l10n.rateYourselfHelp, style: theme.bodySmall),
        for (var i = 0; i < criteria.length; i++)
          CheckboxListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            value: _met.contains(i),
            title: Text(criteria[i]),
            onChanged: (value) => setState(() {
              value! ? _met.add(i) : _met.remove(i);
              _marks = null;
            }),
          ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.suggestedMarks(suggested, widget.maxMarks)),
        Slider(
          value: shown.toDouble(),
          max: widget.maxMarks.toDouble(),
          divisions: widget.maxMarks,
          label: '$shown',
          onChanged: (value) => setState(() => _marks = value.round()),
        ),
        FilledButton(
          onPressed: () {
            setState(() => _marks = shown);
            widget.onMarks(shown);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.scoreSaved)));
          },
          child: Text(l10n.saveMarks(shown, widget.maxMarks)),
        ),
      ],
    );
  }
}
