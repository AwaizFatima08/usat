import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:usat_prep/app.dart';
import 'package:usat_prep/content/content_repository.dart';
import 'package:usat_prep/content/models.dart';
import 'package:usat_prep/ui/async_value_view.dart';
import 'package:usat_prep/ui/theme.dart';

class GuideTab extends ConsumerWidget {
  const GuideTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(guideProvider),
    data: (articles) {
      final groups = <String, List<GuideArticle>>{};
      for (final article in articles) {
        (groups[article.group] ??= []).add(article);
      }
      final catalog = ref.watch(catalogProvider).value;
      final memory = ref.watch(memoryCardsProvider).value ?? const [];
      final withCards = {for (final card in memory) card.section};
      return ListView(
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        children: [
          if (catalog != null && withCards.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
              child: Text(context.l10n.memoryGroup, style: Theme.of(context).textTheme.titleMedium),
            ),
            Text(context.l10n.memoryIntro),
            const SizedBox(height: AppSpacing.sm),
            for (final section in catalog.sections)
              if (withCards.contains(section.key))
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.psychology_alt_outlined),
                    title: Text(section.title),
                    subtitle: Text(
                      context.l10n.memoryCount(
                        memory.where((card) => card.section == section.key).length,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => unawaited(context.push('/memory/${section.key}')),
                  ),
                ),
          ],
          for (final MapEntry(key: group, value: items) in groups.entries) ...[
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
              child: Text(group, style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final article in items)
              Card(
                child: ListTile(
                  title: Text(article.title),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => unawaited(context.push('/guide/${article.id}')),
                ),
              ),
          ],
        ],
      );
    },
  );
}
