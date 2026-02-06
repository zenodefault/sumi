import 'package:flutter/material.dart';
import '../../../core/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/glass_widgets.dart';
import '../../../core/providers.dart';
import '../services/habit_service.dart';
import '../models/habit_model.dart';

class StreakCard extends StatefulWidget {
  const StreakCard({super.key});

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> {
  int _currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    final habits = await HabitService.instance.getHabits();

    int maxStreak = 0;

    for (final habit in habits) {
      final streak = habit.getCurrentStreak();
      if (streak > maxStreak) {
        maxStreak = streak;
      }
    }

    setState(() {
      _currentStreak = maxStreak;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      opacity: 0.22,
      blur: 12,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon representing streaks
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? LightColors.primary.withOpacity(0.1)
                    : DarkColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: AppIcon(
                AppIcons.streak,
                size: 24,
                color: theme.brightness == Brightness.light
                    ? LightColors.primary
                    : DarkColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              'Habit Streak',
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? LightColors.foreground
                    : DarkColors.foreground,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Streak count
            Text(
              '$_currentStreak days',
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? LightColors.primary
                    : DarkColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: (theme.brightness == Brightness.light
                            ? LightColors.primary
                            : DarkColors.primary)
                        .withAlpha(160),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}
