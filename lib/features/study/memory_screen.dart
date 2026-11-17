import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usat_prep/app.dart';
import 'package:usat_prep/content/content_repository.dart';
import 'package:usat_prep/ui/async_value_view.dart';
import 'package:usat_prep/ui/rich_lines.dart';
import 'package:usat_prep/ui/theme.dart';

/// Memory cards of one section: formula sheets, mnemonics and rules to learn by heart.
class MemoryScreen extends ConsumerWidget {
  const MemoryScreen({required this.section, super.key});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider).value;
    final title = catalog?.sections.where((s) => s.key == section).firstOrNull?.title ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.memoryTitle(title))),
      body: AsyncBody(
        value: ref.watch(memoryCardsProvider),
        data: (cards) {
          final mine = [
            for (final card in cards)
              if (card.section == section) card,
          ];
          return ListView(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            children: [
              for (final card in mine)
                Card(
                  child: ExpansionTile(
                    title: Text(card.title),
                    childrenPadding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    children: [RichLines(card.lines)],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
