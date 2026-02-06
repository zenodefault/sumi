import 'package:flutter/material.dart';
import 'dart:ui' as ui show ImageFilter;
import 'app_colors.dart';

/// A reusable glassmorphism container widget
class GlassContainer extends StatelessWidget {
  /// The child widget inside the glass container
  final Widget? child;

  /// Width of the container
  final double? width;

  /// Height of the container
  final double? height;

  /// Background color of the glass effect (defaults to white with low opacity)
  final Color backgroundColor;

  /// Foreground color for the content (text, icons, etc.)
  final Color foregroundColor;

  /// Border radius of the container
  final double borderRadius;

  /// Blur strength for the glass effect
  final double blur;

  /// Opacity of the container (for transparency effect)
  final double opacity;

  /// Border of the container
  final Border? border;

  /// Padding inside the container
  final EdgeInsetsGeometry padding;

  /// Margin around the container
  final EdgeInsetsGeometry margin;

  /// Alignment of the child widget
  final AlignmentGeometry alignment;

  const GlassContainer({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorder = Border.all(
      color: (theme.brightness == Brightness.light
              ? LightColors.border
              : DarkColors.border)
          .withValues(alpha: 0.4),
      width: 1.0,
    );
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
        border: border ?? defaultBorder,
        boxShadow: [
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

/// A glassmorphism card widget
class GlassCard extends StatelessWidget {
  /// The child widget inside the glass card
  final Widget? child;

  /// Background color of the glass effect
  final Color backgroundColor;

  /// Foreground color for the content
  final Color foregroundColor;

  /// Elevation of the card
  final double elevation;

  /// Shape of the card
  final ShapeBorder shape;

  /// Border radius of the card
  final double borderRadius;

  /// Blur strength for the glass effect
  final double blur;

  /// Opacity of the container
  final double opacity;

  /// Padding inside the card
  final EdgeInsetsGeometry padding;

  /// Margin around the card
  final EdgeInsetsGeometry margin;

  const GlassCard({
    Key? key,
    this.child,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.1),
    this.foregroundColor = Colors.white,
    this.elevation = 0.0,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      side: BorderSide.none,
    ),
    this.borderRadius = 20.0,
    this.blur = 10.0,
    this.opacity = 0.15,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorder = BorderSide(
      color: (theme.brightness == Brightness.light
              ? LightColors.border
              : DarkColors.border)
          .withValues(alpha: 0.4),
      width: 1.0,
    );
    final resolvedShape = shape is RoundedRectangleBorder
        ? (shape as RoundedRectangleBorder).copyWith(side: defaultBorder)
        : shape;
    return Card(
      elevation: elevation,
      shape: resolvedShape,
      margin: margin,
      color:
          (theme.brightness == Brightness.light
                  ? LightColors.card
                  : DarkColors.card)
              .withValues(alpha: opacity),
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
                child: child ?? const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A glassmorphism button widget
class GlassButton extends StatelessWidget {
  /// The callback that is called when the button is tapped
  final VoidCallback? onPressed;

  /// The label widget for the button
  final Widget child;

  /// Background color of the glass effect
  final Color backgroundColor;

  /// Foreground color for the content
  final Color foregroundColor;

  /// Border radius of the button
  final double borderRadius;

  /// Blur strength for the glass effect
  final double blur;

  /// Opacity of the container
  final double opacity;

  /// Padding inside the button
  final EdgeInsetsGeometry padding;

  /// Minimum size of the button
  final Size minimumSize;

  /// Whether the button should be enabled
  final bool enabled;

  const GlassButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.1),
    this.foregroundColor = Colors.white,
    this.borderRadius = 16.0,
    this.blur = 10.0,
    this.opacity = 0.15,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    this.minimumSize = const Size(64.0, 48.0),
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color:
            (theme.brightness == Brightness.light
                    ? LightColors.card
                    : DarkColors.card)
                .withValues(alpha: enabled ? opacity : opacity * 0.5),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onPressed : null,
              child: Container(
                padding: padding,
                constraints: BoxConstraints(
                  minWidth: minimumSize.width,
                  minHeight: minimumSize.height,
                ),
                child: Center(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: enabled
                            ? (theme.brightness == Brightness.light
                                  ? LightColors.foreground
                                  : DarkColors.foreground)
                            : (theme.brightness == Brightness.light
                                  ? LightColors.foreground.withValues(
                                      alpha: 0.5,
                                    )
                                  : DarkColors.foreground.withValues(
                                      alpha: 0.5,
                                    )),
                        displayColor: enabled
                            ? (theme.brightness == Brightness.light
                                  ? LightColors.foreground
                                  : DarkColors.foreground)
                            : (theme.brightness == Brightness.light
                                  ? LightColors.foreground.withValues(
                                      alpha: 0.5,
                                    )
                                  : DarkColors.foreground.withValues(
                                      alpha: 0.5,
                                    )),
                      ),
                      iconTheme: IconThemeData(
                        color: enabled
                            ? (theme.brightness == Brightness.light
                                  ? LightColors.foreground
                                  : DarkColors.foreground)
                            : (theme.brightness == Brightness.light
                                  ? LightColors.foreground.withValues(
                                      alpha: 0.5,
                                    )
                                  : DarkColors.foreground.withValues(
                                      alpha: 0.5,
                                    )),
                      ),
                    ),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: enabled
                            ? (theme.brightness == Brightness.light
                                  ? LightColors.foreground
                                  : DarkColors.foreground)
                            : (theme.brightness == Brightness.light
                                  ? LightColors.foreground.withValues(
                                      alpha: 0.5,
                                    )
                                  : DarkColors.foreground.withValues(
                                      alpha: 0.5,
                                    )),
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A glassmorphism text field widget
class GlassTextField extends StatefulWidget {
  /// Controller for the text field
  final TextEditingController? controller;

  /// Hint text for the text field
  final String? hintText;

  /// Label text for the text field
  final String? labelText;

  /// Prefix icon for the text field
  final Widget? prefixIcon;

  /// Suffix icon for the text field
  final Widget? suffixIcon;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when submitted
  final ValueChanged<String>? onSubmitted;

  /// Keyboard type for the text field
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Maximum number of lines
  final int maxLines;

  /// Background color of the glass effect
  final Color backgroundColor;

  /// Foreground color for the content
  final Color foregroundColor;

  /// Border color
  final Color borderColor;

  /// Focused border color
  final Color focusedBorderColor;

  /// Border radius of the text field
  final double borderRadius;

  /// Blur strength for the glass effect
  final double blur;

  /// Opacity of the container
  final double opacity;

  /// Padding inside the text field
  final EdgeInsetsGeometry padding;

  const GlassTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.1),
    this.foregroundColor = Colors.white,
    this.borderColor = const Color.fromRGBO(255, 255, 255, 0.3),
    this.focusedBorderColor = const Color.fromRGBO(255, 255, 255, 0.6),
    this.borderRadius = 16.0,
    this.blur = 10.0,
    this.opacity = 0.15,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  }) : super(key: key);

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color:
            (theme.brightness == Brightness.light
                    ? LightColors.card
                    : DarkColors.card)
                .withValues(alpha: widget.opacity),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _isFocused
              ? (theme.brightness == Brightness.light
                    ? LightColors.primary
                    : DarkColors.primary)
              : (theme.brightness == Brightness.light
                    ? LightColors.muted
                    : DarkColors.muted),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: widget.blur,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: (theme.brightness == Brightness.light
                    ? LightColors.mutedForeground
                    : DarkColors.mutedForeground),
              ),
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: (theme.brightness == Brightness.light
                    ? LightColors.mutedForeground
                    : DarkColors.mutedForeground),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: (theme.brightness == Brightness.light
                            ? LightColors.foreground
                            : DarkColors.foreground),
                      ),
                      child: widget.prefixIcon!,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: (theme.brightness == Brightness.light
                            ? LightColors.foreground
                            : DarkColors.foreground),
                      ),
                      child: widget.suffixIcon!,
                    )
                  : null,
              filled: false,
              border: InputBorder.none,
              contentPadding: widget.padding,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            style: TextStyle(
              color: (theme.brightness == Brightness.light
                  ? LightColors.foreground
                  : DarkColors.foreground),
            ),
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            focusNode: FocusNode()
              ..addListener(() {
                setState(() {
                  _isFocused = FocusNode().hasFocus;
                });
              }),
          ),
        ),
      ),
    );
  }
}
