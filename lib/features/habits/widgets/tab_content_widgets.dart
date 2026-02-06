import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/habit_model.dart';
import 'habit_card.dart';
import '../../../core/glass_widgets.dart';
import '../../../core/app_icons.dart';

// Active Habits Tab
class ActiveHabitsTab extends StatelessWidget {
  final List<Habit> habits;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final VoidCallback onAddHabit;
  final Function(Habit) onToggle;
  final Function(Habit) onEdit;
  final Function(Habit) onDelete;

  const ActiveHabitsTab({
    Key? key,
    required this.habits,
    required this.isLoading,
    required this.onRefresh,
    required this.onAddHabit,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

  return RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: habits.isEmpty ? 2 : habits.length + 1,
        itemBuilder: (context, index) {
          if (habits.isEmpty && index == 0) {
            return _buildEmptyState(
              title: 'No Habits Yet',
              subtitle: 'Start building good habits today',
              showButton: false,
              context: context,
            );
          }

          final isAddCard = index == habits.length || habits.isEmpty;
          if (isAddCard) {
            return _buildAddHabitCard(context, onAddHabit);
          }

          final habit = habits[index];
          return HabitCard(
            habit: habit,
            onToggle: () => onToggle(habit),
            onEdit: () => onEdit(habit),
            onDelete: () => onDelete(habit),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0);
        },
      ),
    );
  }
}

Widget _buildAddHabitCard(BuildContext context, VoidCallback onAddHabit) {
  final theme = Theme.of(context);
  final isLight = theme.brightness == Brightness.light;
  return Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 24),
    child: InkWell(
      onTap: onAddHabit,
      borderRadius: BorderRadius.circular(14),
      child: GlassCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            AppIcon(
              AppIcons.add,
              color: isLight
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Add Habit',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ),
            AppIcon(
              AppIcons.chevronRight,
              color:
                  theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ??
                  Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildEmptyState({
  required String title,
  required String subtitle,
  bool showButton = false,
  VoidCallback? onButtonPressed,
  required BuildContext context,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            AppIcons.habits,
            size: 80,
            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color:
                  Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          if (showButton) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add First Habit'),
            ),
          ],
        ],
      ),
    ),
  );
}
