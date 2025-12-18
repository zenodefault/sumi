// Models for the fitness tracking app

class User {
  final String id;
  final String name;
  final double weight;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.weight,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    double? weight,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
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
  final String videoUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.equipmentNeeded,
    required this.difficultyLevel,
    required this.videoUrl,
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
  final int caloriesConsumed;
  final int caloriesBurned;
  final double weight;

  DailyLog({
    required this.id,
    required this.date,
    required this.completedExercises,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.weight,
  });
}

class FoodItem {
  final String id;
  final String name;
  final int caloriesPerUnit;
  final String unit;
  final String category; // Protein, Carbs, Fats, Vegetables, etc.
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

  int getTotalCalories() => calories * quantity;
}

class Habit {
  final String id;
  final String name;
  final String description;
  final bool completedToday;
  final List<DateTime> completionHistory;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    this.completedToday = false,
    this.completionHistory = const [],
  });

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    bool? completedToday,
    List<DateTime>? completionHistory,
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