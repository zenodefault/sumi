import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/providers.dart';
import '../../../core/models.dart';
import '../../../core/services/food_database_service.dart';
import '../utils/analytics_helpers.dart';
import '../widgets/summary_progress_card.dart';
import '../widgets/section_card.dart';
import '../widgets/calories_line_chart.dart';
import '../widgets/macro_pie_chart.dart';
import '../widgets/chart_legend_row.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _didRefresh = false;
  bool _didEnsureFoodBox = false;

  static const int _days = 7;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRefresh) return;
    _didRefresh = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = Provider.of<FitnessProvider>(context, listen: false);
      provider.updateDailyLogWithCalories();
    });
    if (!_didEnsureFoodBox) {
      _didEnsureFoodBox = true;
      FoodDatabaseService.ensureBoxOpen().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor:
            isLight ? LightColors.foreground : DarkColors.foreground,
        elevation: 0,
      ),
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child) {
          final days = AnalyticsHelpers.getLastNDays(_days);
          final logsByDay =
              AnalyticsHelpers.mapLogsByDay(provider.dailyLogs);
          final caloriesByDay =
              AnalyticsHelpers.mapCaloriesFromFoodLogs(provider.foodLogs);
          final macrosByDay = _mapMacrosFromFoodLogs(provider.foodLogs);
          final habits = provider.habits;

          final dailyCalories = days
              .map(
                (day) => caloriesByDay[day] ??
                    logsByDay[day]?.caloriesConsumed ??
                    0,
              )
              .toList();
          final totalCalories = dailyCalories.fold<int>(
            0,
            (sum, value) => sum + value,
          );
          final avgCalories =
              days.isEmpty ? 0 : totalCalories / days.length;
          final calorieGoal = provider.getTdee();

          final totalCarbs = _totalMacroWithFallback(
            days,
            logsByDay,
            macrosByDay,
            selector: (log) => log.totalCarbs,
            macroKey: 'carbs',
          );
          final totalProtein = _totalMacroWithFallback(
            days,
            logsByDay,
            macrosByDay,
            selector: (log) => log.totalProtein,
            macroKey: 'protein',
          );
          final totalFat = _totalMacroWithFallback(
            days,
            logsByDay,
            macrosByDay,
            selector: (log) => log.totalFat,
            macroKey: 'fat',
          );

          final habitsCompletionRate = AnalyticsHelpers.habitCompletionRate(
            days,
            habits,
            (habit) => habit.completionHistory,
          );

          final totalHabitCompletions = days.fold<int>(0, (sum, day) {
            return sum +
                AnalyticsHelpers.habitsCompletedOnDate(
                  day,
                  habits,
                  (habit) => habit.completionHistory,
                );
          });
          final weekdayLabels =
              days.map(AnalyticsHelpers.weekdayShort).toList();

          return RefreshIndicator(
            color: isLight
                ? LightColors.mutedForeground
                : DarkColors.mutedForeground,
            onRefresh: () async {
              await provider.updateDailyLogWithCalories();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  'Last 7 Days',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? LightColors.foreground
                        : DarkColors.foreground,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SummaryProgressCard(
                        title: 'Calories',
                        valueLabel: '${avgCalories.toStringAsFixed(0)} avg',
                        progress: avgCalories / calorieGoal,
                        deltaLabel:
                            '${totalCalories.toStringAsFixed(0)} total',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryProgressCard(
                        title: 'Habits',
                        valueLabel:
                            '${(habitsCompletionRate * 100).toStringAsFixed(0)}%',
                        progress: habitsCompletionRate,
                        deltaLabel: '$totalHabitCompletions completions',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Calories',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? LightColors.foreground
                        : DarkColors.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${avgCalories.toStringAsFixed(0)} kcal avg / day',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isLight
                              ? LightColors.mutedForeground
                              : DarkColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 12),
                      totalCalories == 0
                          ? const SizedBox(
                              height: 160,
                              child: Center(
                                child: Text('No calorie data yet'),
                              ),
                            )
                          : CaloriesLineChart(
                              values: dailyCalories,
                              labels: weekdayLabels,
                              lineColor: isLight
                                  ? LightColors.chart1
                                  : DarkColors.chart1,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Macros',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? LightColors.foreground
                        : DarkColors.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MacroPieChart(
                        carbs: totalCarbs,
                        protein: totalProtein,
                        fat: totalFat,
                        colors: [
                          isLight
                              ? LightColors.chart1
                              : DarkColors.chart1,
                          isLight
                              ? LightColors.chart2
                              : DarkColors.chart2,
                          isLight
                              ? LightColors.chart4
                              : DarkColors.chart4,
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildMacroLegend(
                        theme,
                        isLight,
                        totalCarbs,
                        totalProtein,
                        totalFat,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMacroLegend(
    ThemeData theme,
    bool isLight,
    double carbs,
    double protein,
    double fat,
  ) {
    final total = carbs + protein + fat;
    String format(double value) =>
        total == 0 ? '0g' : '${value.toStringAsFixed(0)}g';
    String percent(double value) =>
        total == 0 ? '0%' : '${((value / total) * 100).toStringAsFixed(0)}%';

    return ChartLegendRow(
      items: [
        ChartLegendItem(
          label: 'Carbs ${format(carbs)} • ${percent(carbs)}',
          color: isLight ? LightColors.chart1 : DarkColors.chart1,
        ),
        ChartLegendItem(
          label: 'Protein ${format(protein)} • ${percent(protein)}',
          color: isLight ? LightColors.chart2 : DarkColors.chart2,
        ),
        ChartLegendItem(
          label: 'Fat ${format(fat)} • ${percent(fat)}',
          color: isLight ? LightColors.chart4 : DarkColors.chart4,
        ),
      ],
    );
  }

  Map<DateTime, Map<String, double>> _mapMacrosFromFoodLogs(
    List<FoodLog> logs,
  ) {
    final Map<DateTime, Map<String, double>> map = {};
    for (final log in logs) {
      final dayKey = DateTime(
        log.logDate.year,
        log.logDate.month,
        log.logDate.day,
      );
      final food = FoodDatabaseService.getFoodByIdSync(log.foodItemId);
      if (food == null) continue;
      final ratio = log.quantity / 100.0;
      final carbs = food.carbs * ratio;
      final protein = food.protein * ratio;
      final fat = food.fats * ratio;
      final entry = map.putIfAbsent(
        dayKey,
        () => {'carbs': 0.0, 'protein': 0.0, 'fat': 0.0},
      );
      entry['carbs'] = (entry['carbs'] ?? 0) + carbs;
      entry['protein'] = (entry['protein'] ?? 0) + protein;
      entry['fat'] = (entry['fat'] ?? 0) + fat;
    }
    return map;
  }

  double _totalMacroWithFallback(
    List<DateTime> days,
    Map<DateTime, DailyLog> logsByDay,
    Map<DateTime, Map<String, double>> macrosByDay, {
    required double Function(DailyLog) selector,
    required String macroKey,
  }) {
    double total = 0;
    for (final day in days) {
      final macroFromLogs = macrosByDay[day]?[macroKey] ?? 0;
      if (macroFromLogs > 0) {
        total += macroFromLogs;
        continue;
      }
      final log = logsByDay[day];
      if (log != null) {
        total += selector(log);
      }
    }
    return total;
  }
}
