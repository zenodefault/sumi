import 'package:flutter/material.dart';
import '../../../core/glass_widgets.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: padding,
      opacity: 0.22,
      blur: 12,
      child: child,
    );
  }
}
