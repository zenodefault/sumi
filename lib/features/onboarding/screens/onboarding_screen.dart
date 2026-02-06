import 'package:flutter/material.dart';
import '../../../core/app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/glass_widgets.dart';
import '../../../core/models.dart';
import '../../../core/providers.dart';
import '../../../core/navigation.dart';
import '../../habits/services/habit_service.dart';
import '../../habits/models/habit_model.dart' as habit_models;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _step = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  Sex _sex = Sex.other;
  ActivityLevel _activityLevel = ActivityLevel.low;

  final TextEditingController _targetWeightController = TextEditingController();
  String _fitnessFocus = 'General';

  final Map<String, bool> _defaultHabits = {
    'Drink Water': true,
    '10-minute Walk': true,
    'Meditation': true,
  };

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final name = _nameController.text.trim().isEmpty
        ? 'User'
        : _nameController.text.trim();
    final weight = double.tryParse(_weightController.text) ?? 70.0;
    final heightCm = double.tryParse(_heightController.text) ?? 0.0;
    final age = int.tryParse(_ageController.text) ?? 0;
    final targetWeight = int.tryParse(_targetWeightController.text) ?? 0;

    final user = User(
      id: const Uuid().v4(),
      name: name,
      weight: weight,
      age: age,
      sex: _sex,
      heightCm: heightCm,
      activityLevel: _activityLevel,
      createdAt: DateTime.now(),
    );
    final provider = Provider.of<FitnessProvider>(context, listen: false);
    await provider.updateUser(user);
    await provider.updateDailyLogWithCalories();

    final now = DateTime.now();
    final goals = <Goal>[
      if (targetWeight > 0)
        Goal(
          id: const Uuid().v4(),
          title: 'Weight Goal',
          description: 'Target weight',
          targetValue: targetWeight,
          currentValue: weight.round(),
          unit: 'kg',
          startDate: now,
          endDate: now.add(const Duration(days: 90)),
        ),
      Goal(
        id: const Uuid().v4(),
        title: 'Fitness Focus',
        description: _fitnessFocus,
        targetValue: 1,
        currentValue: 1,
        unit: 'focus',
        startDate: now,
        endDate: now,
      ),
    ];
    for (final goal in goals) {
      await provider.addGoal(goal);
    }

    final coreHabits = _defaultHabits.entries
        .where((entry) => entry.value)
        .map(
          (entry) => Habit(
            id: const Uuid().v4(),
            name: entry.key,
            description: '',
            completedToday: false,
            completionHistory: const {},
          ),
        )
        .toList();
    for (final habit in coreHabits) {
      await provider.addHabit(habit);
    }

    final habitList = _defaultHabits.entries
        .where((entry) => entry.value)
        .map(
          (entry) => habit_models.Habit(
            id: const Uuid().v4(),
            name: entry.key,
            description: '',
            category: 'Health',
            priority: 'Medium',
            isDaily: true,
            reminderTime: '08:00',
            startDate: now,
            completionHistory: const {},
            streakHistory: const {},
          ),
        )
        .toList();
    await HabitService.instance.saveHabits(habitList);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    await provider.refreshFromStorage();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AppShell(),
      ),
    );
  }

  void _next() {
    if (_step < 4) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _back() {
    if (_step > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: PageView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) => setState(() => _step = index),
          children: [
            _buildWelcome(theme, isLight),
            _buildProfile(theme, isLight),
            _buildGoals(theme, isLight),
            _buildHabits(theme, isLight),
            _buildFinish(theme, isLight),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(ThemeData theme, bool isLight) {
    return _centeredStep(
      theme,
      title: 'Welcome',
      subtitle:
          'Let’s personalize your plan so you stay motivated and consistent.',
      icon: AppIcons.chart,
      isLight: isLight,
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildProfile(ThemeData theme, bool isLight) {
    return _centeredStep(
      theme,
      title: 'About You',
      subtitle: 'This helps us personalize your goals.',
      icon: AppIcons.user,
      isLight: isLight,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _textField(_nameController, 'Name', isLight: isLight),
            const SizedBox(height: 12),
            _textField(
              _weightController,
              'Weight (kg)',
              keyboardType: TextInputType.number,
              isLight: isLight,
            ),
            const SizedBox(height: 12),
            _textField(
              _heightController,
              'Height (cm)',
              keyboardType: TextInputType.number,
              isLight: isLight,
            ),
            const SizedBox(height: 12),
            _textField(
              _ageController,
              'Age',
              keyboardType: TextInputType.number,
              isLight: isLight,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Sex>(
              value: _sex,
              decoration: const InputDecoration(labelText: 'Sex'),
              items: Sex.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _sex = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ActivityLevel>(
              value: _activityLevel,
              decoration: const InputDecoration(labelText: 'Activity Level'),
              items: const [
                DropdownMenuItem(
                  value: ActivityLevel.low,
                  child: Text('Low active'),
                ),
                DropdownMenuItem(
                  value: ActivityLevel.moderate,
                  child: Text('Moderately active'),
                ),
                DropdownMenuItem(
                  value: ActivityLevel.high,
                  child: Text('Highly active'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _activityLevel = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoals(ThemeData theme, bool isLight) {
    return _centeredStep(
      theme,
      title: 'Goals',
      subtitle: 'Set a target and focus.',
      icon: AppIcons.flag,
      isLight: isLight,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _textField(
              _targetWeightController,
              'Target Weight (kg)',
              keyboardType: TextInputType.number,
              isLight: isLight,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _fitnessFocus,
              decoration: const InputDecoration(labelText: 'Fitness Focus'),
              items: const [
                DropdownMenuItem(value: 'Strength', child: Text('Strength')),
                DropdownMenuItem(value: 'Endurance', child: Text('Endurance')),
                DropdownMenuItem(
                    value: 'Flexibility', child: Text('Flexibility')),
                DropdownMenuItem(value: 'Fat loss', child: Text('Fat loss')),
                DropdownMenuItem(value: 'General', child: Text('General')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _fitnessFocus = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabits(ThemeData theme, bool isLight) {
    return _centeredStep(
      theme,
      title: 'Starter Habits',
      subtitle: 'We can add a few habits to kickstart your streaks.',
      icon: AppIcons.calories,
      isLight: isLight,
      child: GlassCard(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: _defaultHabits.keys.map((habit) {
            return SwitchListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(habit),
              value: _defaultHabits[habit] ?? true,
              onChanged: (value) {
                setState(() {
                  _defaultHabits[habit] = value;
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFinish(ThemeData theme, bool isLight) {
    return _centeredStep(
      theme,
      title: 'You’re Ready',
      subtitle: 'Your plan is set. Let’s start tracking!',
      icon: AppIcons.habits,
      isLight: isLight,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _completeOnboarding,
            child: const Text('Start Tracking'),
          ),
        ),
      ),
    );
  }

  Widget _centeredStep(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required List<List<dynamic>> icon,
    required bool isLight,
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 6),
                      width: index == _step ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _step
                            ? (isLight
                                ? LightColors.primary
                                : DarkColors.primary)
                            : (isLight
                                ? LightColors.mutedForeground.withOpacity(0.25)
                                : DarkColors.mutedForeground.withOpacity(0.25)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GlassContainer(
                  padding: const EdgeInsets.all(12),
                  child: AppIcon(
                    icon,
                    size: 32,
                    color: isLight ? LightColors.primary : DarkColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSymbolRow(isLight),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color:
                        isLight ? LightColors.foreground : DarkColors.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isLight
                        ? LightColors.mutedForeground
                        : DarkColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: child),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_step > 0)
                      TextButton(
                        onPressed: _back,
                        child: const Text('Back'),
                      ),
                    if (_step > 0 && _step < 5) const SizedBox(width: 12),
                    if (_step < 5)
                      ElevatedButton(
                        onPressed: _next,
                        child: const Text('Next'),
                      ),
                  ],
                ),
                if (_step == 1) ...[
                  const SizedBox(height: 10),
                  Text(
                    'We use these info to calculate total kcal required for the day.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isLight
                          ? LightColors.mutedForeground
                          : DarkColors.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSymbolRow(bool isLight) {
    final List<List<List<dynamic>>> icons = _stepSymbols();
    if (icons.isEmpty) return const SizedBox.shrink();
    final color =
        isLight ? LightColors.mutedForeground : DarkColors.mutedForeground;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons
          .map(
            (icon) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppIcon(
                icon,
                size: 16,
                color: color,
              ),
            ),
          )
          .toList(),
    );
  }

  List<List<List<dynamic>>> _stepSymbols() {
    switch (_step) {
      case 0:
        return [AppIcons.dumbbell, AppIcons.calories, AppIcons.habits];
      case 1:
        return [AppIcons.user, AppIcons.flag, AppIcons.chart];
      case 2:
        return [AppIcons.flag, AppIcons.chart, AppIcons.trendUp];
      case 3:
        return [AppIcons.habits, AppIcons.streak, AppIcons.calendar];
      case 4:
        return [AppIcons.notification, AppIcons.time, AppIcons.calendar];
      case 5:
        return [AppIcons.dashboard, AppIcons.analytics, AppIcons.dumbbell];
      default:
        return const [];
    }
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    required bool isLight,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
            (isLight ? Colors.black : Colors.white).withOpacity(0.04),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color:
                (isLight ? Colors.black : Colors.white).withOpacity(0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color:
                (isLight ? Colors.black : Colors.white).withOpacity(0.18),
          ),
        ),
      ),
    );
  }
}
