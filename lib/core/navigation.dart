import 'package:flutter/material.dart';
import '../features/workouts/screens/dashboard_screen.dart';
import '../features/calendar/screens/calendar_screen.dart';
import '../features/anatomy/screens/anatomy_screen.dart';
import '../features/calories/screens/calories_screen.dart';
import '../features/habits/screens/habits_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(), // Workouts/Dashboard
    const CalendarScreen(),  // Calendar
    const AnatomyScreen(),   // Anatomy
    const CaloriesScreen(),  // Calories
    const HabitsScreen(),    // Habits
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        height: 76,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 128,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(0, Icons.apps, 'Dashboard'),
                  _buildBottomNavItem(1, Icons.calendar_today, 'Calendar'),
                  _buildBottomNavItem(2, Icons.accessibility, 'Anatomy'),
                  _buildBottomNavItem(3, Icons.local_fire_department, 'Calories'),
                  _buildBottomNavItem(4, Icons.check_circle_outline, 'Habits'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }
}