import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/habit_model.dart';
import '../../../core/app_icons.dart';
import '../../../core/glass_widgets.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HabitCard({
    required this.habit,
    this.isCompleted = false,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTodayCompleted =
        widget.habit.completionHistory.containsKey(
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
        ) &&
        widget.habit.completionHistory[DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now())] ==
            true;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final theme = Theme.of(context);
        final isLight = theme.brightness == Brightness.light;
        final muted =
            theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey;
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            opacity: isLight ? 0.18 : 0.24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.onToggle,
                      onPanDown: (_) => _animationController.forward(),
                      onPanCancel: () => _animationController.reverse(),
                      onPanEnd: (_) => _animationController.reverse(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isTodayCompleted
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isTodayCompleted
                                ? theme.colorScheme.primary
                                : muted,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isTodayCompleted
                            ? AppIcon(
                                AppIcons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.habit.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.habit.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.habit.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: muted,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      color: theme.cardColor,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          onTap: widget.onEdit,
                        ),
                        PopupMenuItem(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          onTap: widget.onDelete,
                        ),
                      ],
                      child: AppIcon(
                        AppIcons.more,
                        color: muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _chip(
                      widget.habit.category,
                      theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    _chip(
                      widget.habit.priority,
                      _getPriorityColor(widget.habit.priority),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.habit.getSuccessRate().toStringAsFixed(0)}% • ${widget.habit.getCurrentStreak()}d',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Theme.of(context).colorScheme.error;
      case 'medium':
        return Theme.of(context).colorScheme.error;
      case 'low':
        return Theme.of(context).colorScheme.primary;
      default:
        return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    }
  }
}
