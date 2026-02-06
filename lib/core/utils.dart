import 'package:flutter/material.dart';
import 'app_icons.dart';
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
        carbs: 28,
        protein: 2.7,
        fats: 0.3,
      ),
      FoodItem(
        id: 'chapati',
        name: 'Chapati (Whole Wheat)',
        caloriesPerUnit: 104,
        unit: 'per piece (~60g)',
        category: 'Carbs',
        carbs: 18,
        protein: 3.5,
        fats: 2.5,
      ),
      FoodItem(
        id: 'dal',
        name: 'Lentils (Mixed Dal)',
        caloriesPerUnit: 116,
        unit: 'per 100g',
        category: 'Protein',
        carbs: 20,
        protein: 8,
        fats: 1,
      ),
      FoodItem(
        id: 'paneer',
        name: 'Paneer (Cottage Cheese)',
        caloriesPerUnit: 299,
        unit: 'per 100g',
        category: 'Protein',
        carbs: 4,
        protein: 18,
        fats: 22,
      ),
      FoodItem(
        id: 'curd',
        name: 'Curd (Yogurt)',
        caloriesPerUnit: 59,
        unit: 'per 100g',
        category: 'Protein',
        carbs: 3.4,
        protein: 4.3,
        fats: 3.3,
      ),
      FoodItem(
        id: 'aloo',
        name: 'Potato (Aloo)',
        caloriesPerUnit: 77,
        unit: 'per 100g',
        category: 'Carbs',
        carbs: 17,
        protein: 2,
        fats: 0.1,
      ),
      FoodItem(
        id: 'palak',
        name: 'Spinach (Palak)',
        caloriesPerUnit: 23,
        unit: 'per 100g',
        category: 'Vegetables',
        carbs: 3.6,
        protein: 2.9,
        fats: 0.4,
      ),
      FoodItem(
        id: 'ghee',
        name: 'Ghee',
        caloriesPerUnit: 879,
        unit: 'per 100g',
        category: 'Fats',
        carbs: 0,
        protein: 0,
        fats: 100,
      ),
      FoodItem(
        id: 'gobhi',
        name: 'Cauliflower (Gobhi)',
        caloriesPerUnit: 25,
        unit: 'per 100g',
        category: 'Vegetables',
        carbs: 5,
        protein: 2,
        fats: 0.3,
      ),
      FoodItem(
        id: 'chicken',
        name: 'Chicken Breast',
        caloriesPerUnit: 165,
        unit: 'per 100g',
        category: 'Protein',
        carbs: 0,
        protein: 31,
        fats: 3.6,
      ),
    ];
  }
  
  static FoodItem? getFoodByIdSync(String id) {
    return getIndianFoodDatabase().firstWhere((food) => food.id == id, orElse: () => FoodItem(id: '', name: 'Unknown', caloriesPerUnit: 0, unit: 'g', category: ''));
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
          mediaAsset: 'assets/images/exercises/bench_press.webp',
        ),
        Exercise(
          id: 'incline_db_press',
          name: 'Incline Dumbbell Press',
          description: 'Press dumbbells upward on an incline bench to emphasize upper chest.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'Dumbbells/Incline Bench',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/incline_db_press.webp',
        ),
        Exercise(
          id: 'push_ups',
          name: 'Push-ups',
          description: 'Start in plank position and lower your body until chest nearly touches floor, then push back up.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/push_ups.webp',
        ),
        Exercise(
          id: 'chest_fly',
          name: 'Dumbbell Fly',
          description: 'With slight elbow bend, lower dumbbells out to sides and squeeze chest to bring them back up.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'Dumbbells/Bench',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/chest_fly.webp',
        ),
        Exercise(
          id: 'dips',
          name: 'Dips',
          description: 'Lower your body by bending your elbows until upper arms are parallel to floor, then push back up using parallel bars.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'Parallel Bars',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/dips.webp',
        ),
        Exercise(
          id: 'cable_crossover',
          name: 'Cable Crossover',
          description: 'Pull cables down and across the body to meet in front of chest, squeezing at the center.',
          muscleGroup: 'Chest',
          equipmentNeeded: 'Cable Machine',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/cable_crossover.webp',
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
          mediaAsset: 'assets/images/exercises/pull_ups.webp',
        ),
        Exercise(
          id: 'lat_pulldown',
          name: 'Lat Pulldown',
          description: 'Pull bar down to upper chest while keeping torso steady.',
          muscleGroup: 'Back',
          equipmentNeeded: 'Cable Machine',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/lat_pulldown.webp',
        ),
        Exercise(
          id: 'bent_over_row',
          name: 'Bent-over Row',
          description: 'Bend at hips, keep back straight, and pull weights towards your torso.',
          muscleGroup: 'Back',
          equipmentNeeded: 'Dumbbells/Barbell',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/bent_over_row.webp',
        ),
        Exercise(
          id: 'seated_row',
          name: 'Seated Cable Row',
          description: 'Sit with knees slightly bent and pull the handle to your torso.',
          muscleGroup: 'Back',
          equipmentNeeded: 'Cable Machine',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/seated_row.webp',
        ),
        Exercise(
          id: 'deadlift',
          name: 'Deadlift',
          description: 'Lift the barbell from the floor to standing by driving through hips and legs.',
          muscleGroup: 'Back',
          equipmentNeeded: 'Barbell',
          difficultyLevel: 'Advanced',
          mediaAsset: 'assets/images/exercises/deadlift.webp',
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
          mediaAsset: 'assets/images/exercises/shoulder_press.webp',
        ),
        Exercise(
          id: 'arnold_press',
          name: 'Arnold Press',
          description: 'Press dumbbells overhead while rotating palms forward at the top.',
          muscleGroup: 'Shoulders',
          equipmentNeeded: 'Dumbbells',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/arnold_press.webp',
        ),
        Exercise(
          id: 'lateral_raises',
          name: 'Lateral Raises',
          description: 'Raise arms out to sides until parallel to floor, then lower slowly.',
          muscleGroup: 'Shoulders',
          equipmentNeeded: 'Dumbbells',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/lateral_raises.gif',
        ),
        Exercise(
          id: 'front_raises',
          name: 'Front Raises',
          description: 'Lift dumbbells straight in front of you to shoulder height.',
          muscleGroup: 'Shoulders',
          equipmentNeeded: 'Dumbbells',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/front_raises.gif',
        ),
        Exercise(
          id: 'face_pulls',
          name: 'Face Pulls',
          description: 'Pull rope attachment toward your face, keeping elbows high.',
          muscleGroup: 'Shoulders',
          equipmentNeeded: 'Cable Machine',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/face_pulls.gif',
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
          mediaAsset: 'assets/images/exercises/bicep_curls.gif',
        ),
        Exercise(
          id: 'hammer_curls',
          name: 'Hammer Curls',
          description: 'Curl dumbbells with neutral grip to target brachialis.',
          muscleGroup: 'Arms',
          equipmentNeeded: 'Dumbbells',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/hammer_curls.gif',
        ),
        Exercise(
          id: 'tricep_dips',
          name: 'Tricep Dips',
          description: 'Lower your body by bending your elbows until upper arms are parallel to floor, then push back up.',
          muscleGroup: 'Arms',
          equipmentNeeded: 'Parallel Bars/Chair',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/tricep_dips.gif',
        ),
        Exercise(
          id: 'tricep_pushdown',
          name: 'Tricep Pushdown',
          description: 'Extend arms down against cable resistance keeping elbows locked.',
          muscleGroup: 'Arms',
          equipmentNeeded: 'Cable Machine',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/tricep_pushdown.gif',
        ),
        Exercise(
          id: 'overhead_tricep_extension',
          name: 'Overhead Tricep Extension',
          description: 'Extend dumbbell overhead, keeping elbows close to ears.',
          muscleGroup: 'Arms',
          equipmentNeeded: 'Dumbbell',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/overhead_tricep_extension.gif',
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
          mediaAsset: 'assets/images/exercises/squats.gif',
        ),
        Exercise(
          id: 'leg_press',
          name: 'Leg Press',
          description: 'Press the platform away with your feet while keeping back supported.',
          muscleGroup: 'Legs',
          equipmentNeeded: 'Leg Press Machine',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/leg_press.gif',
        ),
        Exercise(
          id: 'lunges',
          name: 'Lunges',
          description: 'Step forward with one leg and lower hips until both knees are bent at 90 degrees.',
          muscleGroup: 'Legs',
          equipmentNeeded: 'None/Dumbbells',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/lunges.gif',
        ),
        Exercise(
          id: 'romanian_deadlift',
          name: 'Romanian Deadlift',
          description: 'Hinge at the hips and lower the barbell while keeping a neutral spine.',
          muscleGroup: 'Legs',
          equipmentNeeded: 'Barbell',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/romanian_deadlift.gif',
        ),
        Exercise(
          id: 'leg_curl',
          name: 'Leg Curl',
          description: 'Curl heels toward glutes on a leg curl machine.',
          muscleGroup: 'Legs',
          equipmentNeeded: 'Leg Curl Machine',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/leg_curl.gif',
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
          mediaAsset: 'assets/images/exercises/plank.gif',
        ),
        Exercise(
          id: 'side_plank',
          name: 'Side Plank',
          description: 'Hold a plank on your side with hips stacked.',
          muscleGroup: 'Core',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/side_plank.gif',
        ),
        Exercise(
          id: 'crunches',
          name: 'Crunches',
          description: 'Lie on back, bend knees, and curl shoulders off floor toward knees.',
          muscleGroup: 'Core',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/crunches.gif',
        ),
        Exercise(
          id: 'russian_twists',
          name: 'Russian Twists',
          description: 'Sit with feet raised and rotate torso side to side.',
          muscleGroup: 'Core',
          equipmentNeeded: 'None/Medicine Ball',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/russian_twists.gif',
        ),
        Exercise(
          id: 'leg_raises',
          name: 'Leg Raises',
          description: 'Lift legs while keeping lower back pressed into the floor.',
          muscleGroup: 'Core',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/leg_raises.gif',
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
          mediaAsset: 'assets/images/exercises/glute_bridge.gif',
        ),
        Exercise(
          id: 'donkey_kicks',
          name: 'Donkey Kicks',
          description: 'On all fours, drive your heel upward to engage glutes.',
          muscleGroup: 'Glutes',
          equipmentNeeded: 'None',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/donkey_kicks.gif',
        ),
        Exercise(
          id: 'hip_thrust',
          name: 'Hip Thrust',
          description: 'Sit against bench, place feet flat on floor, and thrust hips upward.',
          muscleGroup: 'Glutes',
          equipmentNeeded: 'Bench',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/hip_thrust.gif',
        ),
        Exercise(
          id: 'sumo_squat',
          name: 'Sumo Squat',
          description: 'Squat with a wide stance and toes slightly turned out.',
          muscleGroup: 'Glutes',
          equipmentNeeded: 'None/Dumbbell',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/sumo_squat.gif',
        ),
        Exercise(
          id: 'step_ups',
          name: 'Step-ups',
          description: 'Step onto a box or bench, driving through the heel.',
          muscleGroup: 'Glutes',
          equipmentNeeded: 'Box/Bench',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/step_ups.gif',
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
          mediaAsset: 'assets/images/exercises/calf_raises.gif',
        ),
        Exercise(
          id: 'seated_calf_raise',
          name: 'Seated Calf Raise',
          description: 'Raise heels from a seated position to target soleus.',
          muscleGroup: 'Calves',
          equipmentNeeded: 'Seated Calf Machine',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/seated_calf_raise.gif',
        ),
        Exercise(
          id: 'jump_rope',
          name: 'Jump Rope',
          description: 'Jump repeatedly while swinging rope over head and under feet.',
          muscleGroup: 'Calves',
          equipmentNeeded: 'Jump Rope',
          difficultyLevel: 'Beginner',
          mediaAsset: 'assets/images/exercises/jump_rope.gif',
        ),
        Exercise(
          id: 'box_jumps',
          name: 'Box Jumps',
          description: 'Jump onto a sturdy box and step down with control.',
          muscleGroup: 'Calves',
          equipmentNeeded: 'Box',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/box_jumps.gif',
        ),
        Exercise(
          id: 'farmer_walk_toe',
          name: 'Farmer Walk on Toes',
          description: 'Walk on toes while holding weights to challenge calves.',
          muscleGroup: 'Calves',
          equipmentNeeded: 'Dumbbells',
          difficultyLevel: 'Intermediate',
          mediaAsset: 'assets/images/exercises/farmer_walk_toe.gif',
        ),
      ],
    };
  }
  
  // Get icon for muscle group
  static List<List<dynamic>> getMuscleGroupIcon(String muscleGroup) {
    switch (muscleGroup.toLowerCase()) {
      case 'chest':
        return AppIcons.dumbbell;
      case 'back':
        return AppIcons.arrowUp;
      case 'shoulders':
        return AppIcons.anatomy;
      case 'arms':
        return AppIcons.anatomy;
      case 'legs':
        return AppIcons.run;
      case 'core':
        return AppIcons.gymnastics;
      case 'glutes':
        return AppIcons.sports;
      case 'calves':
        return AppIcons.motorsport;
      default:
        return AppIcons.dumbbell;
    }
  }
  
  // Get icon for calorie tracking
  static List<List<dynamic>> getCalorieIcon() {
    return AppIcons.calories;
  }
  
  // Get icon for workout tracking
  static List<List<dynamic>> getWorkoutIcon() {
    return AppIcons.dumbbell;
  }
  
  // Get icon for habit tracking
  static List<List<dynamic>> getHabitIcon() {
    return AppIcons.habits;
  }
  
  // Get icon for calendar
  static List<List<dynamic>> getCalendarIcon() {
    return AppIcons.calendar;
  }
}
