import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils.dart';
import '../../../core/models.dart';

class EnhancedMuscleBodyWidget extends StatefulWidget {
  final Function(String muscleGroup)? onMuscleTap;
  final String? highlightedMuscle;

  const EnhancedMuscleBodyWidget({
    Key? key,
    this.onMuscleTap,
    this.highlightedMuscle,
  }) : super(key: key);

  @override
  State<EnhancedMuscleBodyWidget> createState() => _EnhancedMuscleBodyWidgetState();
}

class _EnhancedMuscleBodyWidgetState extends State<EnhancedMuscleBodyWidget> {
  // Define the positions and sizes for each muscle group
  final Map<String, Map<String, dynamic>> _musclePositions = {
    'Chest': {
      'top': 120.0,
      'left': 80.0,
      'right': 80.0,
      'height': 80.0,
    },
    'Shoulders': {
      'top': 80.0,
      'left': 60.0,
      'width': 50.0,
      'height': 40.0,
    },
    'ShouldersRight': {
      'top': 80.0,
      'right': 60.0,
      'width': 50.0,
      'height': 40.0,
    },
    'Arms': {
      'top': 120.0,
      'left': 20.0,
      'width': 40.0,
      'height': 100.0,
    },
    'ArmsRight': {
      'top': 120.0,
      'right': 20.0,
      'width': 40.0,
      'height': 100.0,
    },
    'Core': {
      'top': 200.0,
      'left': 90.0,
      'right': 90.0,
      'height': 60.0,
    },
    'Back': {
      'top': 200.0,
      'left': 90.0,
      'right': 90.0,
      'height': 60.0,
    },
    'Legs': {
      'top': 270.0,
      'left': 70.0,
      'width': 45.0,
      'height': 120.0,
    },
    'LegsRight': {
      'top': 270.0,
      'right': 70.0,
      'width': 45.0,
      'height': 120.0,
    },
    'Glutes': {
      'top': 260.0,
      'left': 120.0,
      'right': 120.0,
      'height': 30.0,
    },
    'Calves': {
      'top': 390.0,
      'left': 70.0,
      'width': 45.0,
      'height': 60.0,
    },
    'CalvesRight': {
      'top': 390.0,
      'right': 70.0,
      'width': 45.0,
      'height': 60.0,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212), // Dark background as specified
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main body SVG - front view of male body
          Positioned.fill(
            child: Center(
              child: Container(
                width: 250,
                height: 450,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.highlightedMuscle == 'Chest' || widget.highlightedMuscle == 'Core'
                        ? Colors.red
                        : Colors.white,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/anatomy/chest.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          
          // Additional body parts layered on top
          Positioned(
            top: 60,
            left: 100,
            child: Container(
              width: 50,
              height: 40,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Shoulders' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/neck.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 30,
            left: 110,
            child: Container(
              width: 30,
              height: 30,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Head' || widget.highlightedMuscle == 'Shoulders'
                      ? Colors.red
                      : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/head.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 110,
            left: 25,
            child: Container(
              width: 40,
              height: 100,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Arms' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/left-arm.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 110,
            right: 25,
            child: Container(
              width: 40,
              height: 100,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Arms' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/right-arm.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 75,
            left: 65,
            child: Container(
              width: 35,
              height: 35,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Shoulders' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/left-shoulder.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 75,
            right: 65,
            child: Container(
              width: 35,
              height: 35,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Shoulders' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/right-shoulder.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 180,
            left: 80,
            child: Container(
              width: 90,
              height: 60,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Core' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/abdomen.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 260,
            left: 75,
            child: Container(
              width: 40,
              height: 120,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Legs' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/left-leg.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 260,
            right: 75,
            child: Container(
              width: 40,
              height: 120,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.highlightedMuscle == 'Legs' ? Colors.red : Colors.white,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/anatomy/right-leg.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          // Interactive muscle group touch areas
          // Chest - Now highlighted by changing SVG color instead of glow
          Positioned(
            top: _musclePositions['Chest']!['top'],
            left: _musclePositions['Chest']!['left'],
            right: _musclePositions['Chest']!['right'],
            height: _musclePositions['Chest']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Chest'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Shoulders - Left
          Positioned(
            top: _musclePositions['Shoulders']!['top'],
            left: _musclePositions['Shoulders']!['left'],
            width: _musclePositions['Shoulders']!['width'],
            height: _musclePositions['Shoulders']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Shoulders'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Shoulders - Right
          Positioned(
            top: _musclePositions['ShouldersRight']!['top'],
            right: _musclePositions['ShouldersRight']!['right'],
            width: _musclePositions['ShouldersRight']!['width'],
            height: _musclePositions['ShouldersRight']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Shoulders'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Arms - Left
          Positioned(
            top: _musclePositions['Arms']!['top'],
            left: _musclePositions['Arms']!['left'],
            width: _musclePositions['Arms']!['width'],
            height: _musclePositions['Arms']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Arms'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Arms - Right
          Positioned(
            top: _musclePositions['ArmsRight']!['top'],
            right: _musclePositions['ArmsRight']!['right'],
            width: _musclePositions['ArmsRight']!['width'],
            height: _musclePositions['ArmsRight']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Arms'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Core
          Positioned(
            top: _musclePositions['Core']!['top'],
            left: _musclePositions['Core']!['left'],
            right: _musclePositions['Core']!['right'],
            height: _musclePositions['Core']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Core'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Legs - Left
          Positioned(
            top: _musclePositions['Legs']!['top'],
            left: _musclePositions['Legs']!['left'],
            width: _musclePositions['Legs']!['width'],
            height: _musclePositions['Legs']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Legs'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Legs - Right
          Positioned(
            top: _musclePositions['LegsRight']!['top'],
            right: _musclePositions['LegsRight']!['right'],
            width: _musclePositions['LegsRight']!['width'],
            height: _musclePositions['LegsRight']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Legs'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Glutes
          Positioned(
            top: _musclePositions['Glutes']!['top'],
            left: _musclePositions['Glutes']!['left'],
            right: _musclePositions['Glutes']!['right'],
            height: _musclePositions['Glutes']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Glutes'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Calves - Left
          Positioned(
            top: _musclePositions['Calves']!['top'],
            left: _musclePositions['Calves']!['left'],
            width: _musclePositions['Calves']!['width'],
            height: _musclePositions['Calves']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Calves'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
          
          // Calves - Right
          Positioned(
            top: _musclePositions['CalvesRight']!['top'],
            right: _musclePositions['CalvesRight']!['right'],
            width: _musclePositions['CalvesRight']!['width'],
            height: _musclePositions['CalvesRight']!['height'],
            child: GestureDetector(
              onTap: () => widget.onMuscleTap?.call('Calves'),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: null,
              ),
            ),
          ),
        ],
      ),
    );
 }
}