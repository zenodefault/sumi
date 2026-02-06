import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit_model.dart';
import 'package:intl/intl.dart';

class HabitService {
  static const String _habitsKey = 'habits';
  static HabitService? _instance;
  static HabitService get instance => _instance ??= HabitService._();

  HabitService._();

  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _habitsKey,
      jsonEncode(
        habits
            .map(
              (habit) => {
                'id': habit.id,
                'name': habit.name,
                'description': habit.description,
                'category': habit.category,
                'priority': habit.priority,
                'isDaily': habit.isDaily,
                'reminderTime': habit.reminderTime,
                'startDate': habit.startDate.toIso8601String(),
                'completionHistory': habit.completionHistory,
                'streakHistory': habit.streakHistory,
              },
            )
            .toList(),
      ),
    );
  }

  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsData = prefs.getString(_habitsKey);

    if (habitsData != null) {
      final List<dynamic> data = jsonDecode(habitsData);
      return data
          .map(
            (json) => Habit(
              id: json['id'],
              name: json['name'],
              description: json['description'],
              category: json['category'],
              priority: json['priority'],
              isDaily: json['isDaily'],
              reminderTime: json['reminderTime'],
              startDate: DateTime.parse(json['startDate']),
              completionHistory: Map<String, bool>.from(
                json['completionHistory'] ?? {},
              ),
              streakHistory: Map<String, int>.from(json['streakHistory'] ?? {}),
            ),
          )
          .toList();
    }
    return [];
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await getHabits();
    habits.add(habit);
    await saveHabits(habits);
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await saveHabits(habits);
    }
  }

  Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((habit) => habit.id == id);
    await saveHabits(habits);
  }

  // Toggle habit completion for today
  Future<void> toggleHabitCompletion(String id) async {
    final habits = await getHabits();
    final habitIndex = habits.indexWhere((h) => h.id == id);

    if (habitIndex != -1) {
      final habit = habits[habitIndex];
      final today = DateTime.now();
      final todayKey = DateFormat('yyyy-MM-dd').format(today);

      // Create a new completion history map with the updated status
      final newCompletionHistory = Map<String, bool>.from(
        habit.completionHistory,
      );
      final currentStatus = newCompletionHistory[todayKey] ?? false;
      newCompletionHistory[todayKey] = !currentStatus;

      // Update the habit with the new completion history
      final updatedHabit = habit.copyWith(
        completionHistory: newCompletionHistory,
      );
      habits[habitIndex] = updatedHabit;

      await saveHabits(habits);
    }
  }
}
