import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../core/models.dart';
import '../../../core/theme.dart';
import '../../../core/providers.dart';
import '../../../core/utils.dart';
import '../../../core/entry_radial_menu.dart';
import 'workout_day_detail_screen.dart';
import '../../calendar/screens/calendar_screen.dart';
import '../../anatomy/screens/anatomy_screen.dart';
import '../../calories/screens/calories_screen.dart';
import '../../habits/screens/habits_screen.dart';
import '../../todo/screens/todo_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showRadialMenu = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Title
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Metrics grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0, // Square aspect ratio
                  children: [
                    // WORKOUT CARD: Circular counter showing "1", subtitle "Chest + Triceps • Fridays", navigation to Anatomy screen with chest pre-selected
                    _buildWorkoutCard(provider),
                    
                    // CALORIES CARD: Showing "2,100 / 2,500 kcal" with 84% progress bar, navigation to Calorie Tracker with "Indian Foods" tab active
                    _buildCaloriesCard(provider),
                    
                    // HABITS CARD: Showing "5/7 habits • 3-day streak" with flame icon animation for streak, navigation to Habit Tracker screen
                    _buildHabitsCard(provider),
                    
                    // VOLUME CARD: Showing "3,200 lbs" with weekly trend arrow ↑12% and mini bar chart (7 days)
                    _buildVolumeCard(provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ), // This is the body property closing
      floatingActionButton: _showRadialMenu
         ? null // Hide default FAB when radial menu is shown
         : GestureDetector(
             onLongPress: () {
               // Long press - show radial menu
               setState(() {
                 _showRadialMenu = true;
               });
             },
             onTap: () {
               // Short press - show radial menu
               setState(() {
                 _showRadialMenu = true;
               });
             },
             child: FloatingActionButton(
               onPressed: () {
                 // Short press - show radial menu
                 setState(() {
                   _showRadialMenu = true;
                 });
               },
               backgroundColor: FitnessTheme.accentPurple,
               child: const Icon(
                 Icons.add,
                 color: Colors.white,
               ),
             ),
           ),
     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
     // Overlay for radial menu
     extendBody: true,
     bottomSheet: _showRadialMenu
         ? EntryRadialMenu(
             onWorkoutPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => AnatomyScreen(),
                   settings: const RouteSettings(arguments: {'preselectMuscle': 'Chest'}),
                 ),
               );
             },
             onCaloriesPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => CaloriesScreen(),
                   settings: const RouteSettings(arguments: {'activeTab': 'Indian Foods'}),
                 ),
               );
             },
             onHabitPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const HabitsScreen()),
               );
             },
             onTodoPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const TodoScreen()),
               );
             },
             onClose: () {
               setState(() {
                 _showRadialMenu = false;
               });
             },
           )
         : null,
   );
 }

  Widget _buildWorkoutCard(FitnessProvider provider) {
    return GestureDetector(
      onTap: () {
        // Navigate to Anatomy screen with chest pre-selected
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnatomyScreen(),
            settings: const RouteSettings(arguments: {'preselectMuscle': 'Chest'}),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular counter showing "1"
              Container(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: 1.0, // 10% filled
                        strokeWidth: 6,
                        backgroundColor: const Color(0xFF33333),
                        valueColor: AlwaysStoppedAnimation<Color>(FitnessTheme.accentPurple),
                      ),
                    ),
                    const Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Title
              const Text(
                'Chest + Triceps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              // Subtitle
              const Text(
                'Fridays',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }

  Widget _buildCaloriesCard(FitnessProvider provider) {
    // Calculate calories data
    int consumed = 2100; // Today's consumed calories
    int goal = 2500; // Daily goal
    double progress = consumed / goal; // 0.84 (84%)
    
    return GestureDetector(
      onTap: () {
        // Navigate to Calorie Tracker with "Indian Foods" tab active
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaloriesScreen(),
            settings: const RouteSettings(arguments: {'activeTab': 'Indian Foods'}),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Calories text
              Text(
                '${consumed.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")} / ${goal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")} kcal',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              // Progress bar
              Container(
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF33333),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF33333),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Progress percentage
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildHabitsCard(FitnessProvider provider) {
     int completedHabits = 5;
     int totalHabits = 7;
     int streak = 3;
     
     return GestureDetector(
       onTap: () {
         // Navigate to Habit Tracker screen
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => const HabitsScreen(),
           ),
         );
       },
       child: Container(
         decoration: BoxDecoration(
           color: const Color(0xFF1E1E1E),
           borderRadius: BorderRadius.circular(20),
           boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.3),
               blurRadius: 10,
               offset: const Offset(0, 4),
             ),
           ],
         ),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(20),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               // Flame icon for streak
               Icon(
                 Icons.local_fire_department,
                 color: Colors.orange,
                 size: 28,
               ),
               const SizedBox(height: 8),
               // Streak count
               Text(
                 '$streak-day streak',
                 style: const TextStyle(
                   color: Colors.orange,
                   fontSize: 14,
                   fontWeight: FontWeight.w500,
                 ),
               ),
               const SizedBox(height: 12),
               // Habits progress
               Text(
                 '$completedHabits/$totalHabits habits',
                 style: const TextStyle(
                   color: Colors.white,
                   fontSize: 16,
                   fontWeight: FontWeight.w500,
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

 Widget _buildVolumeCard(FitnessProvider provider) {
    String volume = '3,200 lbs';
    String trend = '↑12%';
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Volume text
            Text(
              volume,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Trend indicator
            Text(
              trend,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // Mini bar chart (7 days)
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  // Generate random heights for demonstration
                  double height = 0.3 + (index * 0.1); // Varying heights
                  if (index == 3) height = 0.8; // Peak day
                  
                  return Container(
                    width: 6,
                    height: height * 40,
                    decoration: BoxDecoration(
                      color: FitnessTheme.accentPurple,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

 bool _hasActivity(int day) {
    // Simulate activity on certain days
    return day % 3 == 0 || day % 5 == 0;
  }
}