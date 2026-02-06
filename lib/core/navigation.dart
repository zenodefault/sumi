import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'app_icons.dart';
import 'glass_widgets.dart';
import '../features/workouts/screens/dashboard_screen.dart';
import '../features/anatomy/screens/anatomy_screen.dart';
import '../features/calories/screens/calorie_tracking_screen.dart';
import '../features/habits/screens/habits_screen.dart';
import '../features/analytics/screens/analytics_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final ValueNotifier<int> _selectedIndex;
  late final PageController _pageController;

  final List<Widget> _screens = const [
    DashboardScreen(), // Workouts/Dashboard
    AnalyticsScreen(), // Analytics
    AnatomyScreen(), // Anatomy
    CalorieTrackingScreen(), // Calories
    HabitsScreen(), // Habits
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = ValueNotifier(0);
    _pageController = PageController(initialPage: _selectedIndex.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            allowImplicitScrolling: true,
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (index) {
              _selectedIndex.value = index;
            },
            itemCount: _screens.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(child: _screens[index]);
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: GlassCard(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                borderRadius: 32,
                blur: 18,
                opacity: 0.22,
                child: SizedBox(
                  height: 64,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBottomNavItem(0, AppIcons.dashboard, 'Dashboard'),
                        _buildBottomNavItem(1, AppIcons.analytics, 'Analytics'),
                        _buildBottomNavItem(2, AppIcons.anatomy, 'Anatomy'),
                        _buildBottomNavItem(
                          3,
                          AppIcons.calories,
                          'Calories',
                        ),
                        _buildBottomNavItem(
                          4,
                          AppIcons.habits,
                          'Habits',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    int index,
    List<List<dynamic>> icon,
    String label,
  ) {
    final theme = Theme.of(context);

    return Flexible(
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, child) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              _selectedIndex.value = index;
              _pageController.jumpToPage(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(isSelected ? 8 : 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(25)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: AppIcon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyMedium?.color?.withAlpha(153),
                  size: isSelected ? 26 : 22,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
