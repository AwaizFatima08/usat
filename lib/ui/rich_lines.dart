import 'package:flutter/material.dart';
import 'package:usat_prep/ui/theme.dart';

/// Renders lesson and guide bodies: `## heading`, `- bullet`, `> example` (consecutive lines form one
/// box), `| cell | cell` (consecutive rows form one table, the first row is the header), `! tip`, or a paragraph.
class RichLines extends StatelessWidget {
  const RichLines(this.lines, {super.key});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var example = <String>[];
    var rows = <List<String>>[];
    void flush() {
      if (example.isNotEmpty) children.add(_Box(lines: example, tip: false));
      if (rows.isNotEmpty) children.add(_Table(rows: rows));
      example = [];
      rows = [];
    }

    for (final line in lines) {
      if (line.startsWith('> ') || line == '>') {
        if (rows.isNotEmpty) flush();
        example.add(line.length > 2 ? line.substring(2) : '');
        continue;
      }
      if (line.startsWith('| ')) {
        if (example.isNotEmpty) flush();
        rows.add([for (final cell in line.substring(2).split(' | ')) cell.trim()]);
        continue;
      }
      flush();
      children.add(_line(context, line));
    }
    flush();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }

  Widget _line(BuildContext context, String line) {
    final theme = Theme.of(context).textTheme;
    if (line.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: AppSpacing.md, bottom: AppSpacing.xs),
        child: Text(line.substring(3), style: theme.titleMedium),
      );
    }
    if (line.startsWith('! ')) return _Box(lines: [line.substring(2)], tip: true);
    if (line.startsWith('- ')) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('•  '),
            Expanded(child: Text(line.substring(2), style: const TextStyle(height: 1.45))),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Text(line, style: const TextStyle(height: 1.45)),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.lines, required this.tip});

  final List<String> lines;
  final bool tip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: tip ? scheme.tertiaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: BorderDirectional(
          start: BorderSide(color: tip ? AppColors.amber : scheme.primary, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tip) ...[
            const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.amber),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in lines)
                  Text(
                    line,
                    style: TextStyle(
                      height: 1.45,
                      color: tip ? scheme.onTertiaryContainer : null,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.rows});

  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = rows.map((row) => row.length).reduce((a, b) => a > b ? a : b);
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(color: scheme.outlineVariant),
          children: [
            for (final (i, row) in rows.indexed)
              TableRow(
                decoration: i == 0 ? BoxDecoration(color: scheme.surfaceContainerHighest) : null,
                children: [
                  for (var c = 0; c < width; c++)
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 6),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: Text(
                          c < row.length ? row[c] : '',
                          style: TextStyle(
                            height: 1.35,
                            fontWeight: i == 0 ? FontWeight.w600 : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
