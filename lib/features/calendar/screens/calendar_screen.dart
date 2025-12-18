import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers.dart';
import '../../../core/models.dart';
import '../../../core/utils.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentMonth;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.95,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Generate a list of dates for a given month
  List<DateTime> _getDaysInMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final days = <DateTime>[];

    // Add leading empty days
    int firstWeekday = firstDay.weekday % 7; // Sunday = 0, Monday = 1, etc.
    for (int i = 0; i < firstWeekday; i++) {
      days.add(DateTime(0)); // Placeholder for empty days
    }

    // Add actual days
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(year, month, i));
    }

    return days;
  }

  // Check if a date has workout data
  bool _hasWorkoutOnDate(DateTime date, List<DailyLog> logs) {
    if (date.year == 0) return false; // Placeholder date
    
    return logs.any((log) =>
      log.date.day == date.day &&
      log.date.month == date.month &&
      log.date.year == date.year
    );
  }

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);
    final dailyLogs = fitnessProvider.dailyLogs;
    final theme = Theme.of(context);

    // Set dark theme colors
    final backgroundColor = const Color(0xFF121212);
    final cardBackgroundColor = const Color(0xFF1C1C1E);
    final textColor = Colors.white;
    final accentColor = const Color(0xFFBB86FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Monthly calendar view (Jan-Mar)
          Container(
            height: 350,
            padding: const EdgeInsets.all(16),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _currentMonth = DateTime(DateTime.now().year, DateTime.now().month + index);
                });
              },
              itemCount: 3, // Jan, Feb, Mar
              itemBuilder: (context, index) {
                final monthToShow = DateTime(DateTime.now().year, DateTime.now().month + index);
                
                return Card(
                  color: cardBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '${_getMonthName(monthToShow.month)} ${monthToShow.year}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Weekday headers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        // Calendar grid
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: _getDaysInMonth(monthToShow.year, monthToShow.month).length,
                            itemBuilder: (context, dayIndex) {
                              final day = _getDaysInMonth(monthToShow.year, monthToShow.month)[dayIndex];
                              
                              // Skip placeholder dates
                              if (day.year == 0) {
                                return Container();
                              }
                              
                              final hasWorkout = _hasWorkoutOnDate(day, dailyLogs);
                              final isToday = day.day == DateTime.now().day &&
                                  day.month == DateTime.now().month &&
                                  day.year == DateTime.now().year;
                              
                              return Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isToday ? accentColor.withOpacity(0.2) : Colors.transparent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          day.day.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isToday ? accentColor : textColor,
                                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (hasWorkout)
                                      Positioned(
                                        bottom: 4,
                                        child: Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Indicator dots for page view
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? accentColor : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
          
          // Daily log section with swipeable cards
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDailyLogSection(dailyLogs, accentColor),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new workout functionality
          // Navigate to add workout screen
        },
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildDailyLogSection(List<DailyLog> dailyLogs, Color accentColor) {
    // Sort logs by date (most recent first)
    final sortedLogs = [...dailyLogs]
      ..sort((a, b) => b.date.compareTo(a.date));

    if (sortedLogs.isEmpty) {
      return const Center(
        child: Text(
          'No workouts logged yet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }

    return PageView.builder(
      itemCount: sortedLogs.length,
      itemBuilder: (context, index) {
        final log = sortedLogs[index];
        return _buildDailyLogCard(log, accentColor);
      },
    );
  }

  Widget _buildDailyLogCard(DailyLog log, Color accentColor) {
    final theme = Theme.of(context);
    final cardBackgroundColor = const Color(0xFF1C1C1E);
    
    // Find associated workout data
    final fitnessProvider = Provider.of<FitnessProvider>(context, listen: false);
    final workoutDay = fitnessProvider.workouts.firstWhere(
      (workout) => log.completedExercises.contains(workout.exercises.first),
      orElse: () => WorkoutDay(
        id: '',
        name: 'Custom Workout',
        exercises: log.completedExercises,
        dayOfWeek: '',
      ),
    );

    return Card(
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_getDayName(log.date.weekday)}, ${log.date.day} ${_getMonthName(log.date.month)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${log.completedExercises.length} exercises',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                workoutDay.name,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: log.completedExercises.length > 3
                    ? 3
                    : log.completedExercises.length,
                itemBuilder: (context, index) {
                  final exerciseId = log.completedExercises[index];
                  
                  // Find exercise details
                  String exerciseName = 'Exercise ${index + 1}';
                  String muscleGroup = 'Muscle Group';
                  
                  for (final exercises in fitnessProvider.exerciseDatabase.values) {
                    final exercise = exercises.firstWhere(
                      (e) => e.id == exerciseId,
                      orElse: () => Exercise(
                        id: '',
                        name: 'Unknown Exercise',
                        description: 'No description available',
                        muscleGroup: 'Unknown',
                        equipmentNeeded: 'N/A',
                        difficultyLevel: 'N/A',
                        videoUrl: '',
                      ),
                    );
                    
                    if (exercise.id.isNotEmpty) {
                      exerciseName = exercise.name;
                      muscleGroup = exercise.muscleGroup;
                      break;
                    }
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            exerciseName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          muscleGroup,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration: ${_calculateWorkoutDuration(log)} min',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${log.caloriesBurned} cal burned',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday - 1];
  }

  String _calculateWorkoutDuration(DailyLog log) {
    // In a real app, we would store duration in the model
    // For now, we'll estimate based on number of exercises
    final estimatedMinutes = log.completedExercises.length * 10;
    return estimatedMinutes.toString();
  }
}