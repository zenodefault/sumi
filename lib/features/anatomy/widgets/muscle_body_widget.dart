import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../core/models.dart';

class MuscleBodyWidget extends StatelessWidget {
  final Function(String muscleGroup)? onMuscleTap;
  final List<String>? highlightedMuscles;

  const MuscleBodyWidget({
    Key? key,
    this.onMuscleTap,
    this.highlightedMuscles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title
          Text(
            'Human Muscle Body',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          
          // Muscle body diagram
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Main body image/background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Human Body Diagram',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                
                // Muscle group buttons
                // Chest
                Positioned(
                  top: 80,
                  left: 100,
                  right: 100,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Chest'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Chest') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Chest',
                          style: TextStyle(
                            color: highlightedMuscles?.contains('Chest') == true 
                              ? Colors.white 
                              : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Shoulders
                Positioned(
                  top: 60,
                  left: 70,
                  width: 60,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Shoulders'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Shoulders') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Shoulders',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Shoulders') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 60,
                  right: 70,
                  width: 60,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Shoulders'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Shoulders') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            'Shoulders',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Shoulders') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Arms
                Positioned(
                  top: 120,
                  left: 30,
                  width: 50,
                  height: 100,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Arms'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Arms') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Arms',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Arms') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 120,
                  right: 30,
                  width: 50,
                  height: 100,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Arms'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Arms') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            'Arms',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Arms') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Abs/Core
                Positioned(
                  top: 150,
                  left: 120,
                  right: 120,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Core'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Core') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Abs',
                          style: TextStyle(
                            color: highlightedMuscles?.contains('Core') == true 
                              ? Colors.white 
                              : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Back
                Positioned(
                  top: 150,
                  left: 120,
                  right: 120,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: highlightedMuscles?.contains('Back') == true 
                        ? Colors.green.withOpacity(0.5) 
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: highlightedMuscles?.contains('Back') == true 
                            ? Colors.white 
                            : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Legs
                Positioned(
                  top: 220,
                  left: 100,
                  width: 50,
                  height: 120,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Legs'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Legs') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Legs',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Legs') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 20,
                  right: 10,
                  width: 50,
                  height: 120,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Legs'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Legs') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            'Legs',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Legs') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Glutes
                Positioned(
                  top: 220,
                  left: 150,
                  right: 150,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Glutes'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Glutes') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Glutes',
                          style: TextStyle(
                            color: highlightedMuscles?.contains('Glutes') == true 
                              ? Colors.white 
                              : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Calves
                Positioned(
                  top: 340,
                  left: 100,
                  width: 50,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Calves'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Calves') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Calves',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Calves') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 340,
                  right: 100,
                  width: 50,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => onMuscleTap?.call('Calves'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightedMuscles?.contains('Calves') == true 
                          ? Colors.blue.withOpacity(0.5) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            'Calves',
                            style: TextStyle(
                              fontSize: 10,
                              color: highlightedMuscles?.contains('Calves') == true 
                                ? Colors.white 
                                : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}