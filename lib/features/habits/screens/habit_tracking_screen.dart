import 'dart:async';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/habit_service.dart';
import '../widgets/tab_content_widgets.dart';
import '../widgets/dialog_widgets.dart';
import '../../../core/app_icons.dart';

class HabitTrackingScreen extends StatefulWidget {
  const HabitTrackingScreen({Key? key}) : super(key: key);

  @override
  State<HabitTrackingScreen> createState() => _HabitTrackingScreenState();
}

class _HabitTrackingScreenState extends State<HabitTrackingScreen> {
  List<Habit> _habits = [];
  bool _isLoading = true;
  Timer? _midnightTimer;

  @override
  void initState() {
    super.initState();
    _loadHabits();
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
    _midnightTimer = Timer(duration, () async {
      if (!mounted) return;
      await _loadHabits();
      _scheduleMidnightRefresh();
    });
  }

  Future<void> _loadHabits() async {
    setState(() {
      _isLoading = true;
    });

    _habits = await HabitService.instance.getHabits();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.onBackground,
        title: const Text('Habits'),
        elevation: 0,
        actions: [
          IconButton(
            icon: AppIcon(AppIcons.add),
            onPressed: () => HabitDialogHelper.showAddHabitBottomSheet(
              context: context,
              onHabitAdded: (habit) async {
                await HabitService.instance.addHabit(habit);
                await _loadHabits();
              },
            ),
          ),
        ],
      ),
      body: _buildActiveHabitsTab(),
    );
  }

  Widget _buildActiveHabitsTab() {
    return ActiveHabitsTab(
      habits: _habits,
      isLoading: _isLoading,
      onRefresh: _loadHabits,
      onAddHabit: () => HabitDialogHelper.showAddHabitBottomSheet(
        context: context,
        onHabitAdded: (habit) async {
          await HabitService.instance.addHabit(habit);
          await _loadHabits();
        },
      ),
      onToggle: (habit) async {
        await HabitService.instance.toggleHabitCompletion(habit.id);
        await _loadHabits(); // Refresh the data
      },
      onEdit: (habit) => HabitDialogHelper.showEditHabitBottomSheet(
        context: context,
        habit: habit,
        onHabitUpdated: (updatedHabit) async {
          await HabitService.instance.updateHabit(updatedHabit);
          await _loadHabits();
        },
      ),
      onDelete: (habit) => HabitDialogHelper.showDeleteConfirmation(
        context: context,
        habit: habit,
        onHabitDeleted: (id) async {
          await HabitService.instance.deleteHabit(id);
          await _loadHabits();
        },
      ),
    );
  }
}
