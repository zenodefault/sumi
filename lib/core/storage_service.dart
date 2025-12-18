import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _dailyLogsKey = 'daily_logs';
  static const String _habitsKey = 'habits';
  static const String _goalsKey = 'goals';
  static const String _workoutsKey = 'workouts';
  static const String _foodLogsKey = 'food_logs';

  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  StorageService._();

  Future<SharedPreferences> _prefs() async => await SharedPreferences.getInstance();

  // User data
  Future<void> saveUser(User user) async {
    final prefs = await _prefs();
    await prefs.setString(_userKey, jsonEncode({
      'id': user.id,
      'name': user.name,
      'weight': user.weight,
      'createdAt': user.createdAt.toIso8601String(),
    }));
  }

  Future<User?> getUser() async {
    final prefs = await _prefs();
    final userData = prefs.getString(_userKey);
    
    if (userData != null) {
      final Map<String, dynamic> data = jsonDecode(userData);
      return User(
        id: data['id'],
        name: data['name'],
        weight: data['weight'].toDouble(),
        createdAt: DateTime.parse(data['createdAt']),
      );
    }
    return null;
  }

  // Daily logs
  Future<void> saveDailyLog(DailyLog log) async {
    final prefs = await _prefs();
    final logs = await getDailyLogs();
    
    // Check if log already exists for the date
    final existingIndex = logs.indexWhere((element) => element.date == log.date);
    if (existingIndex != -1) {
      logs[existingIndex] = log;
    } else {
      logs.add(log);
    }
    
    await prefs.setString(_dailyLogsKey, jsonEncode(logs.map((log) => {
      'id': log.id,
      'date': log.date.toIso8601String(),
      'completedExercises': log.completedExercises,
      'caloriesConsumed': log.caloriesConsumed,
      'caloriesBurned': log.caloriesBurned,
      'weight': log.weight,
    }).toList()));
  }

  Future<List<DailyLog>> getDailyLogs() async {
    final prefs = await _prefs();
    final logsData = prefs.getString(_dailyLogsKey);
    
    if (logsData != null) {
      final List<dynamic> data = jsonDecode(logsData);
      return data.map((json) => DailyLog(
        id: json['id'],
        date: DateTime.parse(json['date']),
        completedExercises: List<String>.from(json['completedExercises']),
        caloriesConsumed: json['caloriesConsumed'],
        caloriesBurned: json['caloriesBurned'],
        weight: json['weight'].toDouble(),
      )).toList();
    }
    return [];
  }

  // Habits
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await _prefs();
    await prefs.setString(_habitsKey, jsonEncode(habits.map((habit) => {
      'id': habit.id,
      'name': habit.name,
      'description': habit.description,
      'completedToday': habit.completedToday,
      'completionHistory': habit.completionHistory.map((date) => date.toIso8601String()).toList(),
    }).toList()));
  }

  Future<List<Habit>> getHabits() async {
    final prefs = await _prefs();
    final habitsData = prefs.getString(_habitsKey);
    
    if (habitsData != null) {
      final List<dynamic> data = jsonDecode(habitsData);
      return data.map((json) => Habit(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        completedToday: json['completedToday'],
        completionHistory: List<String>.from(json['completionHistory'])
            .map((dateStr) => DateTime.parse(dateStr))
            .toList(),
      )).toList();
    }
    return [];
  }

  // Goals
  Future<void> saveGoals(List<Goal> goals) async {
    final prefs = await _prefs();
    await prefs.setString(_goalsKey, jsonEncode(goals.map((goal) => {
      'id': goal.id,
      'title': goal.title,
      'description': goal.description,
      'targetValue': goal.targetValue,
      'currentValue': goal.currentValue,
      'unit': goal.unit,
      'startDate': goal.startDate.toIso8601String(),
      'endDate': goal.endDate.toIso8601String(),
    }).toList()));
  }

  Future<List<Goal>> getGoals() async {
    final prefs = await _prefs();
    final goalsData = prefs.getString(_goalsKey);
    
    if (goalsData != null) {
      final List<dynamic> data = jsonDecode(goalsData);
      return data.map((json) => Goal(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        targetValue: json['targetValue'],
        currentValue: json['currentValue'],
        unit: json['unit'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
      )).toList();
    }
    return [];
  }

  // Workouts
  Future<void> saveWorkouts(List<WorkoutDay> workouts) async {
    final prefs = await _prefs();
    await prefs.setString(_workoutsKey, jsonEncode(workouts.map((workout) => {
      'id': workout.id,
      'name': workout.name,
      'exercises': workout.exercises,
      'dayOfWeek': workout.dayOfWeek,
      'isCompleted': workout.isCompleted,
    }).toList()));
  }

  Future<List<WorkoutDay>> getWorkouts() async {
    final prefs = await _prefs();
    final workoutsData = prefs.getString(_workoutsKey);
    
    if (workoutsData != null) {
      final List<dynamic> data = jsonDecode(workoutsData);
      return data.map((json) => WorkoutDay(
        id: json['id'],
        name: json['name'],
        exercises: List<String>.from(json['exercises']),
        dayOfWeek: json['dayOfWeek'],
        isCompleted: json['isCompleted'],
      )).toList();
    }
    return [];
  }

  // Food logs
  Future<void> saveFoodLog(FoodLog log) async {
    final prefs = await _prefs();
    final logs = await getFoodLogs();
    
    // Check if log already exists
    final existingIndex = logs.indexWhere((element) => element.id == log.id);
    if (existingIndex != -1) {
      logs[existingIndex] = log;
    } else {
      logs.add(log);
    }
    
    await prefs.setString(_foodLogsKey, jsonEncode(logs.map((log) => {
      'id': log.id,
      'foodItemId': log.foodItemId,
      'foodName': log.foodName,
      'calories': log.calories,
      'quantity': log.quantity,
      'unit': log.unit,
      'logDate': log.logDate.toIso8601String(),
      'mealType': log.mealType,
    }).toList()));
  }

  Future<List<FoodLog>> getFoodLogs() async {
    final prefs = await _prefs();
    final logsData = prefs.getString(_foodLogsKey);
    
    if (logsData != null) {
      final List<dynamic> data = jsonDecode(logsData);
      return data.map((json) => FoodLog(
        id: json['id'],
        foodItemId: json['foodItemId'],
        foodName: json['foodName'],
        calories: json['calories'],
        quantity: json['quantity'],
        unit: json['unit'],
        logDate: DateTime.parse(json['logDate']),
        mealType: json['mealType'],
      )).toList();
    }
    return [];
  }

  Future<List<FoodLog>> getTodaysFoodLogs() async {
    final allLogs = await getFoodLogs();
    final today = DateTime.now();
    return allLogs.where((log) =>
      log.logDate.day == today.day &&
      log.logDate.month == today.month &&
      log.logDate.year == today.year
    ).toList();
  }

  Future<void> deleteFoodLog(String id) async {
    final prefs = await _prefs();
    final logs = await getFoodLogs();
    logs.removeWhere((log) => log.id == id);
    
    await prefs.setString(_foodLogsKey, jsonEncode(logs.map((log) => {
      'id': log.id,
      'foodItemId': log.foodItemId,
      'foodName': log.foodName,
      'calories': log.calories,
      'quantity': log.quantity,
      'unit': log.unit,
      'logDate': log.logDate.toIso8601String(),
      'mealType': log.mealType,
    }).toList()));
  }
}