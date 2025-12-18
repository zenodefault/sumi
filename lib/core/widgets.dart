import 'package:flutter/material.dart';
import 'dart:math' as math;

class RadialMenu extends StatefulWidget {
  final List<RadialMenuItem> items;
  final Widget child;
  final Duration animationDuration;
  final double radius;
  final VoidCallback? onItemPressed;

  const RadialMenu({
    super.key,
    required this.items,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
    this.radius = 100.0,
    this.onItemPressed,
  });

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isExpanded = !_isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Menu items
        AnimatedBuilder(
          animation: _animation,
          builder: (context, animationChild) {
            return Stack(
              children: List.generate(widget.items.length, (index) {
                double angle = (2 * math.pi / widget.items.length) * index - (math.pi / 2);
                double x = widget.radius * _animation.value * math.cos(angle);
                double y = widget.radius * _animation.value * math.sin(angle);
                
                return Positioned(
                  left: x,
                  top: y,
                  child: Transform.translate(
                    offset: Offset(-x * (1 - _animation.value), -y * (1 - _animation.value)),
                    child: ScaleTransition(
                      scale: _animation,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              widget.items[index].onPressed?.call();
                              widget.onItemPressed?.call();
                              _toggleMenu();
                            },
                            borderRadius: BorderRadius.circular(28),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.items[index].icon,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        // Main button
        GestureDetector(
          onLongPress: _toggleMenu,
          child: widget.child,
        ),
      ],
    );
  }
}

class RadialMenuItem {
  final IconData icon;
  final VoidCallback? onPressed;

  const RadialMenuItem({
    required this.icon,
    this.onPressed,
  });
}