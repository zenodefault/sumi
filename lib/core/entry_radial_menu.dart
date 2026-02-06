import 'package:flutter/material.dart';
import 'app_icons.dart';
import 'dart:math' as math;

class EntryRadialMenu extends StatefulWidget {
  final VoidCallback? onWorkoutPressed;
  final VoidCallback? onCaloriesPressed;
  final VoidCallback? onHabitPressed;
  final VoidCallback? onTodoPressed;
  final VoidCallback? onClose;

  const EntryRadialMenu({
    super.key,
    this.onWorkoutPressed,
    this.onCaloriesPressed,
    this.onHabitPressed,
    this.onTodoPressed,
    this.onClose,
  });

  @override
  State<EntryRadialMenu> createState() => _EntryRadialMenuState();
}

class _EntryRadialMenuState extends State<EntryRadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Create animations for each menu item with stagger effect
    _itemAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.1 * index, 1.0, curve: Curves.elasticOut),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Background tap area to close menu
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    _animationController.reverse().then((_) {
                      widget.onClose?.call();
                    });
                  },
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.5 * _opacityAnimation.value,
                    ),
                  ),
                ),
              ),
              // Radial menu items
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: Stack(
                    children: List.generate(4, (i) {
                      return AnimatedBuilder(
                        animation: _itemAnimations[i],
                        builder: (context, child) {
                          // Calculate position in a circle
                          final angle = (i * 90 - 45) * (math.pi / 180);
                          final radius = 100.0 * _itemAnimations[i].value;
                          final x = 150 + radius * math.cos(angle);
                          final y = 150 + radius * math.sin(angle);

                          return Positioned(
                            left: x - 40,
                            top: y - 40,
                            child: Transform.scale(
                              scale: _itemAnimations[i].value,
                              child: _buildMenuItem(i),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(int index) {
    late List<List<dynamic>> icon;
    late String label;
    late VoidCallback onPressed;

    switch (index) {
      case 0: // Workout
        icon = AppIcons.dumbbell;
        label = 'Workout';
        onPressed = () {
          _animationController.reverse().then((_) {
            widget.onWorkoutPressed?.call();
            widget.onClose?.call();
          });
        };
        break;
      case 1: // Calories
        icon = AppIcons.calories;
        label = 'Calories';
        onPressed = () {
          _animationController.reverse().then((_) {
            widget.onCaloriesPressed?.call();
            widget.onClose?.call();
          });
        };
        break;
      case 2: // Habit
        icon = AppIcons.habits;
        label = 'Habit';
        onPressed = () {
          _animationController.reverse().then((_) {
            widget.onHabitPressed?.call();
            widget.onClose?.call();
          });
        };
        break;
      case 3: // To-Do
        icon = AppIcons.list;
        label = 'To-Do';
        onPressed = () {
          _animationController.reverse().then((_) {
            widget.onTodoPressed?.call();
            widget.onClose?.call();
          });
        };
        break;
      default:
        icon = AppIcons.help;
        label = 'Unknown';
        onPressed = () {};
        break;
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
