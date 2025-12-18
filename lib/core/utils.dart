import 'package:flutter/material.dart';
import 'models.dart';

class AppConstants {
  static const String appName = 'Fitness Tracker';
  
  // Muscle groups for the anatomy feature
  static const List<String> muscleGroups = [
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Legs',
    'Core',
    'Glutes',
    'Calves'
  ];
  
  // Days of the week
  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
}

class AppUtils {
  // Format date as DD/MM/YYYY
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  // Calculate BMI
  static double calculateBMI(double weight, double height) {
    // Height in meters
    return weight / (height * height);
  }
  
  // Get Indian food database (sample data)
  static List<FoodItem> getIndianFoodDatabase() {
    return [
      FoodItem(
        id: 'rice',
        name: 'Rice (Basmati)',
        caloriesPerUnit: 130,
        unit: 'per 100g',
        category: 'Carbs',
      ),
      FoodItem(
        id: 'chapati',
        name: 'Chapati (Whole Wheat)',
        caloriesPerUnit: 104,
        unit: 'per piece (~60g)',
        category: 'Carbs',
      ),
      FoodItem(
        id: 'dal',
        name: 'Lentils (Mixed Dal)',
        caloriesPerUnit: 116,
        unit: 'per 100g',
        category: 'Protein',
      ),
      FoodItem(
        id: 'paneer',
        name: 'Paneer (Cottage Cheese)',
        caloriesPerUnit: 299,
        unit: 'per 100g',
        category: 'Protein',
      ),
      FoodItem(
        id: 'curd',
        name: 'Curd (Yogurt)',
        caloriesPerUnit: 59,
        unit: 'per 100g',
        category: 'Protein',
      ),
      FoodItem(
        id: 'aloo',
        name: 'Potato (Aloo)',
        caloriesPerUnit: 77,
        unit: 'per 100g',
        category: 'Carbs',
      ),
      FoodItem(
        id: 'palak',
        name: 'Spinach (Palak)',
        caloriesPerUnit: 23,
        unit: 'per 100g',
        category: 'Vegetables',
      ),
      FoodItem(
        id: 'ghee',
        name: 'Ghee',
        caloriesPerUnit: 879,
        unit: 'per 100g',
        category: 'Fats',
      ),
      FoodItem(
        id: 'gobhi',
        name: 'Cauliflower (Gobhi)',
        caloriesPerUnit: 25,
        unit: 'per 100g',
        category: 'Vegetables',
      ),
      FoodItem(
        id: 'chicken',
        name: 'Chicken Breast',
        caloriesPerUnit: 165,
        unit: 'per 100g',
        category: 'Protein',
      ),
    ];
  }
  
  // Sample exercises database organized by muscle group
  static Map<String, List<Exercise>> getExerciseDatabase() {
    return {
      'Chest': [
        Exercise(
          id: 'bench_press',
          name: 'Bench Press',
          description: 'Lie on a bench and press weights upward using a grip slightly wider than shoulder-width.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'Barbell/Bench',
          difficultyLevel: 'Intermediate',
          videoUrl: 'https://example.com/bench_press',
        ),
        Exercise(
          id: 'push_ups',
          name: 'Push-ups',
          description: 'Start in plank position and lower your body until chest nearly touches floor, then push back up.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/pushups',
        ),
        Exercise(
          id: 'dips',
          name: 'Dips',
          description: 'Lower your body by bending your elbows until upper arms are parallel to floor, then push back up using parallel bars.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'Parallel Bars',
          difficultyLevel: 'Intermediate',
          videoUrl: 'https://example.com/dips',
        ),
      ],
      'Back': [
        Exercise(
          id: 'pull_ups',
          name: 'Pull-ups',
          description: 'Grab a pull-up bar with overhand grip and pull your body up until chin is above the bar.',
          muscleGroup: 'Back',
          equipmentNeeded: 'Pull-up Bar',
          difficultyLevel: 'Intermediate',
          videoUrl: 'https://example.com/pullups',
        ),
        Exercise(
          id: 'bent_over_row',
          name: 'Bent-over Row',
          description: 'Bend at hips, keep back straight, and pull weights towards your torso.',
          muscleGroup: 'Back',
          equipmentNeeded: 'Dumbbells/Barbell',
          difficultyLevel: 'Intermediate',
          videoUrl: 'https://example.com/bentoverrow',
        ),
      ],
      'Shoulders': [
        Exercise(
          id: 'shoulder_press',
          name: 'Shoulder Press',
          description: 'Press weights overhead from shoulder height, extending arms completely.',
          muscleGroup: 'Shoulders',
          equipmentNeeded: 'Dumbbells/Barbell',
          difficultyLevel: 'Intermediate',
          videoUrl: 'https://example.com/shoulderpress',
        ),
        Exercise(
          id: 'lateral_raises',
          name: 'Lateral Raises',
          description: 'Raise arms out to sides until parallel to floor, then lower slowly.',
          muscleGroup: 'Shoulders',
          equipmentNeeded: 'Dumbbells',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/lateralraises',
        ),
      ],
      'Arms': [
        Exercise(
          id: 'bicep_curls',
          name: 'Bicep Curls',
          description: 'Curl dumbbells or barbell toward shoulders while keeping elbows stationary.',
          muscleGroup: 'Arms',
          equipmentNeeded: 'Dumbbells/Barbell',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/bicepcurls',
        ),
        Exercise(
          id: 'tricep_dips',
          name: 'Tricep Dips',
          description: 'Lower your body by bending your elbows until upper arms are parallel to floor, then push back up.',
          muscleGroup: 'Arms',
          equipmentNeeded: 'Parallel Bars/Chair',
          difficultyLevel: 'Intermediate',
          videoUrl: 'https://example.com/tricepdips',
        ),
      ],
      'Legs': [
        Exercise(
          id: 'squats',
          name: 'Squats',
          description: 'Lower your body by bending knees and hips until thighs are parallel to floor, then stand back up.',
          muscleGroup: 'Legs',
          equipmentNeeded: 'None/Barbell',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/squats',
        ),
        Exercise(
          id: 'lunges',
          name: 'Lunges',
          description: 'Step forward with one leg and lower hips until both knees are bent at 90 degrees.',
          muscleGroup: 'Legs',
          equipmentNeeded: 'None/Dumbbells',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/lunges',
        ),
      ],
      'Core': [
        Exercise(
          id: 'plank',
          name: 'Plank',
          description: 'Hold a push-up position with body straight from head to heels, engaging core muscles.',
          muscleGroup: 'Core',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/plank',
        ),
        Exercise(
          id: 'crunches',
          name: 'Crunches',
          description: 'Lie on back, bend knees, and curl shoulders off floor toward knees.',
          muscleGroup: 'Core',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/crunches',
        ),
      ],
      'Glutes': [
        Exercise(
          id: 'glute_bridge',
          name: 'Glute Bridge',
          description: 'Lie on back, bend knees, and lift hips until body forms straight line from knees to shoulders.',
          muscleGroup: 'Glutes',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/glutebridge',
        ),
        Exercise(
          id: 'hip_thrust',
          name: 'Hip Thrust',
          description: 'Sit against bench, place feet flat on floor, and thrust hips upward.',
          muscleGroup: 'Glutes',
          equipmentNeeded: 'Bench',
          difficultyLevel: 'Intermediate',
          videoUrl: 'https://example.com/hipthrust',
        ),
      ],
      'Calves': [
        Exercise(
          id: 'calf_raises',
          name: 'Calf Raises',
          description: 'Stand with feet hip-width apart and raise up onto toes, then lower slowly.',
          muscleGroup: 'Calves',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/calfraises',
        ),
        Exercise(
          id: 'jump_rope',
          name: 'Jump Rope',
          description: 'Jump repeatedly while swinging rope over head and under feet.',
          muscleGroup: 'Calves',
          equipmentNeeded: 'Jump Rope',
          difficultyLevel: 'Beginner',
          videoUrl: 'https://example.com/jumprope',
        ),
      ],
    };
  }
  
  // Get icon for muscle group
  static IconData getMuscleGroupIcon(String muscleGroup) {
    switch (muscleGroup.toLowerCase()) {
      case 'chest':
        return Icons.fitness_center;
      case 'back':
        return Icons.arrow_upward;
      case 'shoulders':
        return Icons.accessibility;
      case 'arms':
        return Icons.accessibility_new;
      case 'legs':
        return Icons.directions_run;
      case 'core':
        return Icons.sports_gymnastics;
      case 'glutes':
        return Icons.sports;
      case 'calves':
        return Icons.sports_motorsports;
      default:
        return Icons.fitness_center;
    }
  }
  
  // Get icon for calorie tracking
  static IconData getCalorieIcon() {
    return Icons.local_fire_department;
  }
  
  // Get icon for workout tracking
  static IconData getWorkoutIcon() {
    return Icons.fitness_center;
  }
  
  // Get icon for habit tracking
  static IconData getHabitIcon() {
    return Icons.check_circle_outline;
  }
  
  // Get icon for calendar
  static IconData getCalendarIcon() {
    return Icons.calendar_today;
  }
}