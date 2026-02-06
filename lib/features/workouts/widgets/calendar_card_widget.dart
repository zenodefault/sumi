import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers.dart';
import '../../../core/models.dart';
import '../../../core/app_colors.dart';
import '../../../core/glass_widgets.dart';

class CalendarCardWidget extends StatefulWidget {
  const CalendarCardWidget({super.key});

  @override
  State<CalendarCardWidget> createState() => _CalendarCardWidgetState();
}

class _CalendarCardWidgetState extends State<CalendarCardWidget> {
  Timer? _midnightTimer;
  DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _scheduleMidnightRefresh();
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    super.dispose();
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day).add(
      const Duration(days: 1),
    );
    final duration = nextMidnight.difference(now);
    _midnightTimer = Timer(duration, () {
      if (!mounted) return;
      setState(() {
        _today = DateTime.now();
      });
      _scheduleMidnightRefresh();
    });
  }

  // Get days in a month
  List<DateTime> _getDaysInMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final days = <DateTime>[];

    // Add leading empty days
    int firstWeekday = firstDay.weekday % 7; // Sunday = 0, Monday = 1, etc.
    for (int i = 0; i < firstWeekday; i++) {
      days.add(DateTime(0)); // Placeholder for empty days
    }

    // Add actual days
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(year, month, i));
    }

    return days;
  }

  // Check if a date has completed exercises
  bool _hasExerciseCompletionOnDate(DateTime date, List<DailyLog> logs) {
    if (date.year == 0) return false; // Placeholder date

    return logs.any(
      (log) =>
          log.date.day == date.day &&
          log.date.month == date.month &&
          log.date.year == date.year &&
          log.completedExercises.isNotEmpty,
    );
  }

  bool _hasHabitCompletionOnDate(DateTime date, List<Habit> habits) {
    if (date.year == 0) return false;
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    return habits.any((habit) => habit.completionHistory[dateKey] == true);
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);
    final dailyLogs = fitnessProvider.dailyLogs;
    final habits = fitnessProvider.habits;
    final theme = Theme.of(context);

    // Get current, previous, and next months
    DateTime currentDate = _today;
    DateTime prevMonth = DateTime(currentDate.year, currentDate.month - 1, 1);
    DateTime currMonth = DateTime(currentDate.year, currentDate.month, 1);
    DateTime nextMonth = DateTime(currentDate.year, currentDate.month + 1, 1);

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      opacity: 0.22,
      blur: 12,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Workout Calendar',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.light
                    ? LightColors.foreground
                    : DarkColors.foreground,
              ),
            ),
            const SizedBox(height: 8), // Reduced spacing
            // Three months in a row
            Row(
              children: [
                Expanded(
                  child: _buildMonthColumn(prevMonth, dailyLogs, habits, theme),
                ),
                const SizedBox(width: 8), // Reduced spacing
                Expanded(
                  child: _buildMonthColumn(currMonth, dailyLogs, habits, theme),
                ),
                const SizedBox(width: 8), // Reduced spacing
                Expanded(
                  child: _buildMonthColumn(nextMonth, dailyLogs, habits, theme),
                ),
              ],
            ),
          ],
      ),
    );
  }

  // Build a column for a single month
  Widget _buildMonthColumn(
    DateTime month,
    List<DailyLog> logs,
    List<Habit> habits,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.brightness == Brightness.light
              ? LightColors.muted
              : DarkColors.muted,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          // Month header
          Text(
            '${_getMonthName(month.month)} ${month.year}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: theme.brightness == Brightness.light
                  ? LightColors.foreground
                  : DarkColors.foreground,
            ),
          ),
          const SizedBox(height: 4), // Reduced spacing
          // Weekday headers
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: theme.brightness == Brightness.light
                                ? LightColors.mutedForeground
                                : DarkColors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // Calendar grid
          Container(
            height:
                70, // Further reduced height for calendar grid to prevent overflow
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: _getDaysInMonth(month.year, month.month).length,
              itemBuilder: (context, dayIndex) {
                final day = _getDaysInMonth(month.year, month.month)[dayIndex];

                // Skip placeholder dates
                if (day.year == 0) {
                  return const SizedBox(); // More efficient than Container
                }

                final hasExercise = _hasExerciseCompletionOnDate(day, logs);
                final hasHabit = _hasHabitCompletionOnDate(day, habits);
                final hasFullCompletion = hasExercise && hasHabit;
                final isToday =
                    day.day == _today.day &&
                    day.month == _today.month &&
                    day.year == _today.year;

                // Simplified approach - just return the dot
                const double dotSize = 3;

                if (hasFullCompletion) {
                  const glowColor = Color.fromARGB(255, 236, 178, 102);
                  return Center(
                    child: SizedBox(
                      width: dotSize + 1,
                      height: dotSize + 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: glowColor,
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withAlpha(140),
                              spreadRadius: 1.4,
                              blurRadius: 3.6,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Center(
                  child: SizedBox(
                    width: dotSize,
                    height: dotSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToday
                            ? (theme.brightness == Brightness.light
                                  ? LightColors.primary
                                  : DarkColors.primary)
                            : (theme.brightness == Brightness.light
                                  ? LightColors.mutedForeground.withAlpha(120)
                                  : DarkColors.mutedForeground.withAlpha(120)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
