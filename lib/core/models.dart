// Models for the fitness tracking app

enum Sex { male, female, other }

enum ActivityLevel { low, moderate, high }

class User {
  final String id;
  final String name;
  final double weight;
  final int age;
  final Sex sex;
  final double heightCm;
  final ActivityLevel activityLevel;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.weight,
    required this.age,
    required this.sex,
    required this.heightCm,
    required this.activityLevel,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    double? weight,
    int? age,
    Sex? sex,
    double? heightCm,
    ActivityLevel? activityLevel,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      activityLevel: activityLevel ?? this.activityLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final String muscleGroup;
  final String equipmentNeeded;
  final String difficultyLevel;
  final String mediaAsset;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.equipmentNeeded,
    required this.difficultyLevel,
    required this.mediaAsset,
  });
}

class ExerciseEntry {
  final String exerciseId;
  final int sets;
  final int reps;
  final DateTime timestamp;

  ExerciseEntry({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.timestamp,
  });
}

class WorkoutDay {
  final String id;
  final String name;
  final List<String> exercises; // List of exercise IDs
  final String dayOfWeek;
  final bool isCompleted;

  WorkoutDay({
    required this.id,
    required this.name,
    required this.exercises,
    required this.dayOfWeek,
    this.isCompleted = false,
  });
}

class DailyLog {
  final String id;
  final DateTime date;
  final List<String> completedExercises; // List of exercise IDs
  final List<ExerciseEntry> exerciseEntries;
  final int caloriesConsumed;
  final int caloriesBurned;
  final double weight;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;
  final bool didExerciseToday;

  DailyLog({
    required this.id,
    required this.date,
    required this.completedExercises,
    this.exerciseEntries = const [],
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.weight,
    this.totalCarbs = 0.0,
    this.totalProtein = 0.0,
    this.totalFat = 0.0,
    this.didExerciseToday = false,
  });
}

class FoodItem {
  final String id;
  final String name;
  final int caloriesPerUnit;
  final String unit;
  final String category; // Protein, Carbs, Fats, Vegetables, etc.
  final double carbs;
  final double protein;
  final double fats;
  final String? barcode; // Optional barcode for Open Food Facts
  final String? brand; // Optional brand information
  final String? imageUrl; // Optional product image
  final Map<String, dynamic>? nutriments; // Optional detailed nutrition data

  FoodItem({
    required this.id,
    required this.name,
    required this.caloriesPerUnit,
    required this.unit,
    required this.category,
    this.carbs = 0.0,
    this.protein = 0.0,
    this.fats = 0.0,
    this.barcode,
    this.brand,
    this.imageUrl,
    this.nutriments,
  });
}

// Model for logging consumed food items
class FoodLog {
  final String id;
  final String foodItemId;
  final String foodName;
  final int calories;
  final int quantity; // Quantity in units
  final String unit; // Unit of measurement
  final DateTime logDate;
  final String mealType; // Breakfast, Lunch, Dinner, Snack, etc.

  FoodLog({
    required this.id,
    required this.foodItemId,
    required this.foodName,
    required this.calories,
    required this.quantity,
    required this.unit,
    required this.logDate,
    this.mealType = 'General',
  });

  int getTotalCalories() => calories;
}

class Habit {
  final String id;
  final String name;
  final String description;
  final bool completedToday;
  final Map<String, bool> completionHistory;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    this.completedToday = false,
    this.completionHistory = const {},
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    bool? completedToday,
    Map<String, bool>? completionHistory,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      completedToday: completedToday ?? this.completedToday,
      completionHistory: completionHistory ?? this.completionHistory,
    );
  }
}

class Goal {
  final String id;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final String unit; // e.g., "lbs", "days", "reps", "calories"
  final DateTime startDate;
  final DateTime endDate;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.startDate,
    required this.endDate,
  });

  double get progressPercentage => (currentValue / targetValue) * 100;
}
