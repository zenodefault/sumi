import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/glass_widgets.dart';

class SummaryProgressCard extends StatelessWidget {
  final String title;
  final String valueLabel;
  final double progress;
  final String? deltaLabel;

  const SummaryProgressCard({
    super.key,
    required this.title,
    required this.valueLabel,
    required this.progress,
    this.deltaLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final clamped = progress.clamp(0.0, 1.0);

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      opacity: 0.22,
      blur: 12,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isLight
                    ? LightColors.mutedForeground
                    : DarkColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              valueLabel,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isLight ? LightColors.foreground : DarkColors.foreground,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: clamped,
              minHeight: 6,
              backgroundColor: isLight ? LightColors.muted : DarkColors.muted,
              valueColor: AlwaysStoppedAnimation<Color>(
                isLight ? LightColors.primary : DarkColors.primary,
              ),
            ),
            if (deltaLabel != null) ...[
              const SizedBox(height: 6),
              Text(
                deltaLabel!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isLight
                      ? LightColors.mutedForeground
                      : DarkColors.mutedForeground,
                ),
              ),
            ],
          ],
      ),
    );
  }
}
