import 'package:flutter/foundation.dart';
import 'models.dart';
import 'storage_service.dart';
import 'utils.dart';

class FitnessProvider extends ChangeNotifier {
  User? _user;
  List<DailyLog> _dailyLogs = [];
 List<Habit> _habits = [];
  List<Goal> _goals = [];
  List<WorkoutDay> _workouts = [];
  List<FoodItem> _foodDatabase = [];
  List<FoodLog> _foodLogs = [];
  Map<String, List<Exercise>> _exerciseDatabase = {};

  User? get user => _user;
  List<DailyLog> get dailyLogs => _dailyLogs;
  List<Habit> get habits => _habits;
  List<Goal> get goals => _goals;
  List<WorkoutDay> get workouts => _workouts;
  List<FoodItem> get foodDatabase => _foodDatabase;
  List<FoodLog> get foodLogs => _foodLogs;
  Map<String, List<Exercise>> get exerciseDatabase => _exerciseDatabase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FitnessProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    // Load user data
    _user = await StorageService.instance.getUser();
    
    // Load other data
    _dailyLogs = await StorageService.instance.getDailyLogs();
    _habits = await StorageService.instance.getHabits();
    _goals = await StorageService.instance.getGoals();
    _workouts = await StorageService.instance.getWorkouts();
    
    // Initialize databases
    _foodDatabase = AppUtils.getIndianFoodDatabase();
    _exerciseDatabase = AppUtils.getExerciseDatabase();
    _foodLogs = await StorageService.instance.getFoodLogs();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    _user = user;
    await StorageService.instance.saveUser(user);
    notifyListeners();
  }

  Future<void> addDailyLog(DailyLog log) async {
    _dailyLogs.add(log);
    await StorageService.instance.saveDailyLog(log);
    notifyListeners();
  }

  Future<void> updateDailyLog(DailyLog log) async {
    final index = _dailyLogs.indexWhere((element) => element.id == log.id);
    if (index != -1) {
      _dailyLogs[index] = log;
      await StorageService.instance.saveDailyLog(log);
      notifyListeners();
    }
  }

  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await StorageService.instance.saveHabits(_habits);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((element) => element.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await StorageService.instance.saveHabits(_habits);
      notifyListeners();
    }
  }

  Future<void> addGoal(Goal goal) async {
    _goals.add(goal);
    await StorageService.instance.saveGoals(_goals);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((element) => element.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      await StorageService.instance.saveGoals(_goals);
      notifyListeners();
    }
  }

  Future<void> addWorkout(WorkoutDay workout) async {
    _workouts.add(workout);
    await StorageService.instance.saveWorkouts(_workouts);
    notifyListeners();
  }

  Future<void> updateWorkout(WorkoutDay workout) async {
    final index = _workouts.indexWhere((element) => element.id == workout.id);
    if (index != -1) {
      _workouts[index] = workout;
      await StorageService.instance.saveWorkouts(_workouts);
      notifyListeners();
    }
  }

  // Get today's log
  DailyLog? getTodaysLog() {
    final today = DateTime.now();
    final foundLog = _dailyLogs.firstWhere(
      (log) => log.date.day == today.day &&
               log.date.month == today.month &&
               log.date.year == today.year,
      orElse: () => DailyLog(
        id: '',
        date: DateTime(0), // Use a zero date to indicate no log found
        completedExercises: [],
        caloriesConsumed: 0,
        caloriesBurned: 0,
        weight: 0.0,
      ),
    );
    
    // If the date is zero, it means no log was found for today
    if (foundLog.date == DateTime(0)) {
      return null;
    }
    
    return foundLog;
  }

  // Get calories consumed today
  int getTodaysCaloriesConsumed() {
    final todayLog = getTodaysLog();
    return todayLog?.caloriesConsumed ?? 0;
  }

  // Get completed exercises today
  List<String> getTodaysCompletedExercises() {
    final todayLog = getTodaysLog();
    return todayLog?.completedExercises ?? [];
  }

  // Get user's current weight
  double getCurrentWeight() {
    if (_user != null) {
      return _user!.weight;
    }
    
    // If no user data, check today's log
    final todayLog = getTodaysLog();
    if (todayLog != null) {
      return todayLog.weight;
    }
    
    // Default weight
    return 70.0;
  }

  // Get workouts for a specific day
  List<WorkoutDay> getWorkoutsForDay(String day) {
    return _workouts.where((workout) => workout.dayOfWeek == day).toList();
  }

 // Get exercises for a specific workout
  List<Exercise> getExercisesForWorkout(String workoutId) {
    final workout = _workouts.firstWhere((w) => w.id == workoutId, orElse: () => WorkoutDay(id: '', name: '', exercises: [], dayOfWeek: ''));
    return workout.exercises.map((id) {
      for (final exercises in _exerciseDatabase.values) {
        final exercise = exercises.firstWhere((e) => e.id == id, orElse: () => Exercise(
          id: '',
          name: 'Unknown Exercise',
          description: 'No description available',
          muscleGroup: 'Unknown',
          equipmentNeeded: 'N/A',
          difficultyLevel: 'N/A',
          videoUrl: '',
        ));
        if (exercise.id.isNotEmpty) return exercise;
      }
      return Exercise(
        id: '',
        name: 'Unknown Exercise',
        description: 'No description available',
        muscleGroup: 'Unknown',
        equipmentNeeded: 'N/A',
        difficultyLevel: 'N/A',
        videoUrl: '',
      );
    }).where((exercise) => exercise.id.isNotEmpty).toList();
  }

  // Food logs management
  Future<void> addFoodLog(FoodLog log) async {
    _foodLogs.add(log);
    await StorageService.instance.saveFoodLog(log);
    notifyListeners();
  }

  Future<void> updateFoodLog(FoodLog log) async {
    final index = _foodLogs.indexWhere((element) => element.id == log.id);
    if (index != -1) {
      _foodLogs[index] = log;
      await StorageService.instance.saveFoodLog(log);
      notifyListeners();
    }
  }

  Future<void> deleteFoodLog(String id) async {
    _foodLogs.removeWhere((log) => log.id == id);
    await StorageService.instance.deleteFoodLog(id);
    notifyListeners();
  }

  List<FoodLog> getTodaysFoodLogs() {
    final today = DateTime.now();
    return _foodLogs.where((log) =>
      log.logDate.day == today.day &&
      log.logDate.month == today.month &&
      log.logDate.year == today.year
    ).toList();
  }

  int getTodaysTotalCalories() {
    return getTodaysFoodLogs().fold(0, (sum, log) => sum + log.getTotalCalories());
  }

  // Update daily log with total calories consumed
  Future<void> updateDailyLogWithCalories() async {
    final today = DateTime.now();
    final existingLog = _dailyLogs.firstWhere(
      (log) => log.date.day == today.day &&
               log.date.month == today.month &&
               log.date.year == today.year,
      orElse: () => DailyLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: today,
        completedExercises: [],
        caloriesConsumed: 0,
        caloriesBurned: 0,
        weight: getCurrentWeight(),
      ),
    );

    final updatedLog = DailyLog(
      id: existingLog.id.isNotEmpty ? existingLog.id : DateTime.now().millisecondsSinceEpoch.toString(),
      date: today,
      completedExercises: existingLog.completedExercises,
      caloriesConsumed: getTodaysTotalCalories(),
      caloriesBurned: existingLog.caloriesBurned,
      weight: existingLog.weight,
    );

    if (existingLog.id.isNotEmpty) {
      await updateDailyLog(updatedLog);
    } else {
      await addDailyLog(updatedLog);
    }
  }
}