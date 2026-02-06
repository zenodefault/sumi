import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class ChartLegendRow extends StatelessWidget {
  final List<ChartLegendItem> items;

  const ChartLegendRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.color,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isLight
                        ? LightColors.mutedForeground
                        : DarkColors.mutedForeground,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class ChartLegendItem {
  final String label;
  final Color color;

  const ChartLegendItem({required this.label, required this.color});
}
