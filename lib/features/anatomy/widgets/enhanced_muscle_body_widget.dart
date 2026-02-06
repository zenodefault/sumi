import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EnhancedMuscleBodyWidget extends StatefulWidget {
  final Function(String muscleGroup)? onMuscleTap;
  final String? highlightedMuscle;

  const EnhancedMuscleBodyWidget({
    Key? key,
    this.onMuscleTap,
    this.highlightedMuscle,
  }) : super(key: key);

  @override
  State<EnhancedMuscleBodyWidget> createState() =>
      _EnhancedMuscleBodyWidgetState();
}

class _EnhancedMuscleBodyWidgetState extends State<EnhancedMuscleBodyWidget> {
  // Fractional layout rects (0..1) to keep parts aligned across screen sizes.
  static const double _bodyAspectRatio = 250 / 450;

  static const Map<String, Rect> _partRects = {
    'Head': Rect.fromLTWH(0.44, 0.02, 0.12, 0.10),
    'Neck': Rect.fromLTWH(0.43, 0.12, 0.14, 0.08),
    'LeftShoulder': Rect.fromLTWH(0.18, 0.18, 0.18, 0.10),
    'RightShoulder': Rect.fromLTWH(0.64, 0.18, 0.18, 0.10),
    'LeftArm': Rect.fromLTWH(0.06, 0.24, 0.20, 0.28),
    'RightArm': Rect.fromLTWH(0.74, 0.24, 0.20, 0.28),
    'Chest': Rect.fromLTWH(0.30, 0.20, 0.40, 0.18),
    'Core': Rect.fromLTWH(0.32, 0.38, 0.36, 0.14),
    'LeftLeg': Rect.fromLTWH(0.30, 0.54, 0.18, 0.36),
    'RightLeg': Rect.fromLTWH(0.52, 0.54, 0.18, 0.36),
  };

  static const Map<String, Rect> _hitRects = {
    'Chest': Rect.fromLTWH(0.28, 0.20, 0.44, 0.22),
    'ShouldersLeft': Rect.fromLTWH(0.16, 0.17, 0.20, 0.12),
    'ShouldersRight': Rect.fromLTWH(0.64, 0.17, 0.20, 0.12),
    'ArmsLeft': Rect.fromLTWH(0.05, 0.24, 0.22, 0.30),
    'ArmsRight': Rect.fromLTWH(0.73, 0.24, 0.22, 0.30),
    'Core': Rect.fromLTWH(0.30, 0.36, 0.40, 0.18),
    'LegsLeft': Rect.fromLTWH(0.28, 0.54, 0.22, 0.38),
    'LegsRight': Rect.fromLTWH(0.50, 0.54, 0.22, 0.38),
    'Glutes': Rect.fromLTWH(0.34, 0.50, 0.32, 0.08),
    'CalvesLeft': Rect.fromLTWH(0.30, 0.74, 0.18, 0.18),
    'CalvesRight': Rect.fromLTWH(0.52, 0.74, 0.18, 0.18),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212), // Dark background as specified
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          double bodyWidth = maxWidth;
          double bodyHeight = bodyWidth / _bodyAspectRatio;

          if (bodyHeight > maxHeight) {
            bodyHeight = maxHeight;
            bodyWidth = bodyHeight * _bodyAspectRatio;
          }

          return Center(
            child: SizedBox(
              width: bodyWidth,
              height: bodyHeight,
              child: Stack(
                children: [
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['Head']!,
                    asset: 'assets/images/anatomy/head.svg',
                    highlight: widget.highlightedMuscle == 'Head' ||
                        widget.highlightedMuscle == 'Shoulders',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['Neck']!,
                    asset: 'assets/images/anatomy/neck.svg',
                    highlight: widget.highlightedMuscle == 'Shoulders',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['LeftShoulder']!,
                    asset: 'assets/images/anatomy/left-shoulder.svg',
                    highlight: widget.highlightedMuscle == 'Shoulders',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['RightShoulder']!,
                    asset: 'assets/images/anatomy/right-shoulder.svg',
                    highlight: widget.highlightedMuscle == 'Shoulders',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['LeftArm']!,
                    asset: 'assets/images/anatomy/left-arm.svg',
                    highlight: widget.highlightedMuscle == 'Arms',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['RightArm']!,
                    asset: 'assets/images/anatomy/right-arm.svg',
                    highlight: widget.highlightedMuscle == 'Arms',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['Chest']!,
                    asset: 'assets/images/anatomy/chest.svg',
                    highlight: widget.highlightedMuscle == 'Chest',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['Core']!,
                    asset: 'assets/images/anatomy/abdomen.svg',
                    highlight: widget.highlightedMuscle == 'Core',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['LeftLeg']!,
                    asset: 'assets/images/anatomy/left-leg.svg',
                    highlight: widget.highlightedMuscle == 'Legs',
                  ),
                  _buildPart(
                    bodyWidth,
                    bodyHeight,
                    rect: _partRects['RightLeg']!,
                    asset: 'assets/images/anatomy/right-leg.svg',
                    highlight: widget.highlightedMuscle == 'Legs',
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['Chest']!,
                    onTap: () => widget.onMuscleTap?.call('Chest'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['ShouldersLeft']!,
                    onTap: () => widget.onMuscleTap?.call('Shoulders'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['ShouldersRight']!,
                    onTap: () => widget.onMuscleTap?.call('Shoulders'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['ArmsLeft']!,
                    onTap: () => widget.onMuscleTap?.call('Arms'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['ArmsRight']!,
                    onTap: () => widget.onMuscleTap?.call('Arms'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['Core']!,
                    onTap: () => widget.onMuscleTap?.call('Core'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['LegsLeft']!,
                    onTap: () => widget.onMuscleTap?.call('Legs'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['LegsRight']!,
                    onTap: () => widget.onMuscleTap?.call('Legs'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['Glutes']!,
                    onTap: () => widget.onMuscleTap?.call('Glutes'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['CalvesLeft']!,
                    onTap: () => widget.onMuscleTap?.call('Calves'),
                  ),
                  _buildHitArea(
                    bodyWidth,
                    bodyHeight,
                    rect: _hitRects['CalvesRight']!,
                    onTap: () => widget.onMuscleTap?.call('Calves'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPart(
    double bodyWidth,
    double bodyHeight, {
    required Rect rect,
    required String asset,
    required bool highlight,
  }) {
    return Positioned(
      left: rect.left * bodyWidth,
      top: rect.top * bodyHeight,
      width: rect.width * bodyWidth,
      height: rect.height * bodyHeight,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          highlight ? Colors.red : Colors.white,
          BlendMode.srcIn,
        ),
        child: SvgPicture.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildHitArea(
    double bodyWidth,
    double bodyHeight, {
    required Rect rect,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: rect.left * bodyWidth,
      top: rect.top * bodyHeight,
      width: rect.width * bodyWidth,
      height: rect.height * bodyHeight,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: const SizedBox.expand(),
      ),
    );
  }
}
