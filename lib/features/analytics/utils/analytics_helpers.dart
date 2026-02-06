import '../../../core/models.dart';

class AnalyticsHelpers {
  static const int defaultDays = 7;

  static List<DateTime> getLastNDays(int days) {
    final today = DateTime.now();
    return List.generate(days, (index) {
      final date = today.subtract(Duration(days: days - 1 - index));
      return DateTime(date.year, date.month, date.day);
    });
  }

  static Map<DateTime, DailyLog> mapLogsByDay(List<DailyLog> logs) {
    final Map<DateTime, DailyLog> map = {};
    for (final log in logs) {
      final key = DateTime(log.date.year, log.date.month, log.date.day);
      map[key] = log;
    }
    return map;
  }

  static Map<DateTime, int> mapCaloriesFromFoodLogs(List<FoodLog> logs) {
    final Map<DateTime, int> map = {};
    for (final log in logs) {
      final key = DateTime(log.logDate.year, log.logDate.month, log.logDate.day);
      map[key] = (map[key] ?? 0) + log.getTotalCalories();
    }
    return map;
  }

  static int totalExercisesCompleted(
    List<DateTime> days,
    Map<DateTime, DailyLog> logsByDay,
  ) {
    int total = 0;
    for (final day in days) {
      total += logsByDay[day]?.completedExercises.length ?? 0;
    }
    return total;
  }

  static int totalCalories(
    List<DateTime> days,
    Map<DateTime, DailyLog> logsByDay,
  ) {
    int total = 0;
    for (final day in days) {
      total += logsByDay[day]?.caloriesConsumed ?? 0;
    }
    return total;
  }

  static double avgCalories(
    List<DateTime> days,
    Map<DateTime, DailyLog> logsByDay,
  ) {
    if (days.isEmpty) return 0;
    return totalCalories(days, logsByDay) / days.length;
  }

  static double avgMacro(
    List<DateTime> days,
    Map<DateTime, DailyLog> logsByDay, {
    required double Function(DailyLog) selector,
  }) {
    if (days.isEmpty) return 0;
    double total = 0;
    for (final day in days) {
      final log = logsByDay[day];
      if (log != null) {
        total += selector(log);
      }
    }
    return total / days.length;
  }

  static double totalMacro(
    List<DateTime> days,
    Map<DateTime, DailyLog> logsByDay, {
    required double Function(DailyLog) selector,
  }) {
    double total = 0;
    for (final day in days) {
      final log = logsByDay[day];
      if (log != null) {
        total += selector(log);
      }
    }
    return total;
  }

  static int habitsCompletedOnDate(
    DateTime day,
    List<Habit> habits,
    Map<String, bool> Function(Habit) historySelector,
  ) {
    final key = _dateKey(day);
    int completed = 0;
    for (final habit in habits) {
      if (historySelector(habit)[key] == true) {
        completed += 1;
      }
    }
    return completed;
  }

  static double habitCompletionRate(
    List<DateTime> days,
    List<Habit> habits,
    Map<String, bool> Function(Habit) historySelector,
  ) {
    if (habits.isEmpty || days.isEmpty) return 0;
    int completed = 0;
    for (final day in days) {
      completed += habitsCompletedOnDate(day, habits, historySelector);
    }
    final totalPossible = habits.length * days.length;
    return totalPossible == 0 ? 0 : completed / totalPossible;
  }

  static String weekdayShort(DateTime day) {
    switch (day.weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'T';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '';
    }
  }

  static String _dateKey(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return '${normalized.year.toString().padLeft(4, '0')}-'
        '${normalized.month.toString().padLeft(2, '0')}-'
        '${normalized.day.toString().padLeft(2, '0')}';
  }
}
