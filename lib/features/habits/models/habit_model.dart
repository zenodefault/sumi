import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category; // "Health", "Fitness", "Mindfulness", "Productivity"

  @HiveField(4)
  final String priority; // "High", "Medium", "Low"

  @HiveField(5)
  final bool isDaily;

  @HiveField(6)
  final String reminderTime; // "HH:MM" format

  @HiveField(7)
  final DateTime startDate;

  @HiveField(8)
  final Map<String, bool> completionHistory; // {date: isCompleted}

  @HiveField(9)
  final Map<String, int> streakHistory; // {date: streakCount}

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.priority,
    required this.isDaily,
    required this.reminderTime,
    required this.startDate,
    Map<String, bool>? completionHistory,
    Map<String, int>? streakHistory,
  }) : completionHistory = completionHistory ?? {},
       streakHistory = streakHistory ?? {};

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? priority,
    bool? isDaily,
    String? reminderTime,
    DateTime? startDate,
    Map<String, bool>? completionHistory,
    Map<String, int>? streakHistory,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isDaily: isDaily ?? this.isDaily,
      reminderTime: reminderTime ?? this.reminderTime,
      startDate: startDate ?? this.startDate,
      completionHistory: completionHistory ?? this.completionHistory,
      streakHistory: streakHistory ?? this.streakHistory,
    );
  }

  // Calculate current streak
  int getCurrentStreak() {
    if (completionHistory.isEmpty) return 0;

    // Get today's date
    final today = DateTime.now();
    String todayKey = DateFormat('yyyy-MM-dd').format(today);

    // If today isn't completed, we need to check yesterday and work backwards
    if (!completionHistory.containsKey(todayKey) ||
        !completionHistory[todayKey]!) {
      return _calculateStreakUntil(today.subtract(const Duration(days: 1)));
    }

    // If today is completed, calculate from today
    return _calculateStreakUntil(today);
  }

  int _calculateStreakUntil(DateTime date) {
    int streak = 0;
    DateTime currentDate = date;

    while (true) {
      String dateKey = DateFormat('yyyy-MM-dd').format(currentDate);

      if (completionHistory.containsKey(dateKey) &&
          completionHistory[dateKey] == true) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  // Calculate success rate percentage
  double getSuccessRate() {
    if (completionHistory.isEmpty) return 0.0;

    int completed = completionHistory.values.where((value) => value).length;
    return (completed / completionHistory.length) * 100;
  }

  // Get completion count for the last 7 days
  int getRecentCompletionCount() {
    final today = DateTime.now();
    int count = 0;

    for (int i = 0; i < 7; i++) {
      DateTime date = today.subtract(Duration(days: i));
      String dateKey = DateFormat('yyyy-MM-dd').format(date);

      if (completionHistory.containsKey(dateKey) &&
          completionHistory[dateKey]!) {
        count++;
      }
    }

    return count;
  }
}
