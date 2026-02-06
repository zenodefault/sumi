import 'package:flutter/material.dart';
import 'dart:ui' as ui show ImageFilter;
import 'app_colors.dart';

/// A glassmorphism card specifically designed for dashboard items
class GlassDashboardCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final BoxShadow? boxShadow;

  const GlassDashboardCard({
    super.key,
    required this.child,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.1),
    this.foregroundColor = Colors.white,
    this.borderRadius = 20.0,
    this.blur = 12.0,
    this.opacity = 0.15,
    this.padding = const EdgeInsets.all(20.0),
    this.margin = const EdgeInsets.all(8.0),
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTap = onTap != null;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color:
            (theme.brightness == Brightness.light
                    ? LightColors.card
                    : DarkColors.card)
                .withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: (theme.brightness == Brightness.light
              ? LightColors.muted
              : DarkColors.muted),
          width: 0.5,
        ),
        boxShadow: [
          if (boxShadow != null) boxShadow!,
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: blur,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                  displayColor: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                ),
                iconTheme: IconThemeData(
                  color: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (hasTap) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}

/// Enhanced glass container with more customization options
class EnhancedGlassContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Border? border;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final AlignmentGeometry alignment;
  final List<BoxShadow>? shadows;

  const EnhancedGlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.1),
    this.foregroundColor = Colors.white,
    this.borderRadius = 20.0,
    this.blur = 10.0,
    this.opacity = 0.15,
    this.border,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
    this.alignment = Alignment.center,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color:
            (theme.brightness == Brightness.light
                    ? LightColors.card
                    : DarkColors.card)
                .withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow:
            shadows ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: blur,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            alignment: alignment,
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                  displayColor: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                ),
                iconTheme: IconThemeData(
                  color: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: (theme.brightness == Brightness.light
                      ? LightColors.foreground
                      : DarkColors.foreground),
                ),
                child: child ?? const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
