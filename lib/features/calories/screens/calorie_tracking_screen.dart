import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import '../../../core/app_colors.dart';
import '../../../core/glass_widgets.dart';
import '../../../core/providers.dart';
import '../../../core/storage_service.dart';
import '../../../core/models.dart';
import '../../../core/app_icons.dart';

import '../../../core/services/food_database_service.dart';
import '../../../models/indian_food_model.dart';
import '../widgets/food_search_bottom_sheet.dart';

class CalorieTrackingScreen extends StatefulWidget {
  const CalorieTrackingScreen({super.key});

  @override
  State<CalorieTrackingScreen> createState() => _CalorieTrackingScreenState();
}

class _CalorieTrackingScreenState extends State<CalorieTrackingScreen> {
  bool _didRefresh = false;

  @override
  void initState() {
    super.initState();
  }

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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<FitnessProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await provider.updateDailyLogWithCalories();
                if (mounted) {
                  setState(() {});
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Removed app bar with menu and profile icons
              // Removed date navigator
              const SizedBox(height: 24),
              Text(
                'Calorie Calculator',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: isLight ? LightColors.foreground : DarkColors.foreground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Corresponds to lines 7-15: Today's Summary card
              _buildSummaryCard(theme, isLight, provider),

              const SizedBox(height: 24),

              // Use provider to rebuild when refresh happens
              Builder(
                builder: (context) {
                  final foodLogs = provider.getTodaysFoodLogs();

                  // Group food logs by meal type
                  final Map<String, List<FoodLog>> meals = {
                    'Breakfast': [],
                    'Lunch': [],
                    'Dinner': [],
                    'Snacks': [],
                  };

                  for (var log in foodLogs) {
                    String mealType = log.mealType;
                    // Normalize meal types to match our keys
                    if (mealType.toLowerCase() == 'snack') {
                      mealType = 'Snacks';
                    }
                    if (meals.containsKey(mealType)) {
                      meals[mealType]?.add(log);
                    } else {
                      meals['Snacks']?.add(
                        log,
                      ); // Default to snacks for unknown meal types
                    }
                  }

                  return Column(
                    children: [
                      // Corresponds to lines 17-21: Breakfast section
                      _buildMealCard(
                        theme: theme,
                        isLight: isLight,
                        meal: 'Breakfast',
                        entries: meals['Breakfast']!,
                        provider: provider,
                      ),

                      const SizedBox(height: 16),

                      // Corresponds to lines 23-27: Lunch section
                      _buildMealCard(
                        theme: theme,
                        isLight: isLight,
                        meal: 'Lunch',
                        entries: meals['Lunch']!,
                        provider: provider,
                      ),

                      const SizedBox(height: 16),

                      // Corresponds to lines 29-33: Dinner section
                      _buildMealCard(
                        theme: theme,
                        isLight: isLight,
                        meal: 'Dinner',
                        entries: meals['Dinner']!,
                        provider: provider,
                      ),

                      const SizedBox(height: 16),

                      // Add the new "Snacks" section
                      _buildMealCard(
                        theme: theme,
                        isLight: isLight,
                        meal: 'Snacks',
                        entries: meals['Snacks']!,
                        provider: provider,
                      ),
                      const SizedBox(height: 16),
                      _buildAddFoodCard(theme, isLight),
                    ],
                  );
                },
              ),

              const SizedBox(height: 80), // Extra space for nav overlap
            ],
          ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, bool isLight) {
    // Return empty container since we're removing the app bar elements
    return Container();
  }

  Widget _buildDateNavigator(ThemeData theme, bool isLight) {
    // Return empty container since we're removing the date navigator
    return Container();
  }

  Widget _buildSummaryCard(
    ThemeData theme,
    bool isLight,
    FitnessProvider provider,
  ) {
    final todayLog = provider.getTodaysLog();
    final calorieGoal = provider.getTdee();
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16.0),
      opacity: 0.22,
      blur: 12,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calories', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            // Using a RichText to style the current and total calories differently if needed
            Text.rich(
              TextSpan(
                text: todayLog?.caloriesConsumed.toStringAsFixed(0) ?? '0',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: isLight ? LightColors.primary : DarkColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: ' / ${calorieGoal.toStringAsFixed(0)} kcal',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isLight
                          ? LightColors.mutedForeground
                          : DarkColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (todayLog?.caloriesConsumed ?? 0) / calorieGoal,
              backgroundColor: isLight ? LightColors.muted : DarkColors.muted,
              valueColor: AlwaysStoppedAnimation<Color>(
                isLight ? LightColors.primary : DarkColors.primary,
              ),
              minHeight: 10,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Carbs: ${todayLog?.totalCarbs.toStringAsFixed(0) ?? '0'}g',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Protein: ${todayLog?.totalProtein.toStringAsFixed(0) ?? '0'}g',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Fat: ${todayLog?.totalFat.toStringAsFixed(0) ?? '0'}g',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildMealCard({
    required ThemeData theme,
    required bool isLight,
    required String meal,
    required List<FoodLog> entries,
    required FitnessProvider provider,
  }) {
    // Calculate total calories for the meal
    double totalCalories = 0;
    for (var entry in entries) {
      totalCalories += entry.calories;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(meal, style: theme.textTheme.titleLarge),
              Text(
                '${totalCalories.toStringAsFixed(0)} kcal',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isLight
                      ? LightColors.mutedForeground
                      : DarkColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16.0),
          opacity: 0.22,
          blur: 12,
          child: Column(
              children: entries.isEmpty
                  ? [
                      // Placeholder for an empty meal
                      Center(
                        child: Text(
                          'No items added yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isLight
                                ? LightColors.mutedForeground
                                : DarkColors.mutedForeground,
                          ),
                        ),
                      ),
                    ]
                  : List.generate(entries.length, (index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${entry.foodName} (${entry.quantity}${entry.unit})',
                                style: theme.textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${entry.calories.toStringAsFixed(0)} kcal',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                IconButton(
                                  icon: AppIcon(
                                    AppIcons.delete,
                                    color: isLight
                                        ? LightColors.mutedForeground
                                        : DarkColors.mutedForeground,
                                  ),
                                  onPressed: () {
                                    _deleteFoodLog(entry.id, provider);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            ),
        ),
      ],
    );
  }

  void _deleteFoodLog(String id, FitnessProvider provider) {
    provider.deleteFoodLog(id).then((_) async {
      await provider.updateDailyLogWithCalories();
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget _buildAddFoodCard(ThemeData theme, bool isLight) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: theme.cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => FoodSearchBottomSheet(
            onFoodAdded: (food, grams, meal) async {
              final foodLog = FoodLog(
                id: Uuid().v4(),
                foodItemId: food.id,
                foodName: food.name,
                calories: (food.calories * (grams / 100)).toInt(),
                quantity: grams.toInt(),
                unit: 'g',
                logDate: DateTime.now(),
                mealType: meal,
              );

              final provider = Provider.of<FitnessProvider>(
                context,
                listen: false,
              );
              await provider.addFoodLog(foodLog);
              await provider.updateDailyLogWithCalories();
              if (mounted) {
                setState(() {});
              }
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: GlassCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        opacity: 0.22,
        blur: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              AppIcons.add,
              color: isLight ? LightColors.primary : DarkColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Food',
              style: theme.textTheme.titleMedium?.copyWith(
                color:
                    isLight ? LightColors.foreground : DarkColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
