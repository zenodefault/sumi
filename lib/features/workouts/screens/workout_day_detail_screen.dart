import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers.dart';
import '../../../core/models.dart';
import 'exercise_detail_screen.dart';

class WorkoutDayDetailScreen extends StatelessWidget {
  final WorkoutDay workoutDay;

  const WorkoutDayDetailScreen({
    Key? key,
    required this.workoutDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutDay.name),
        centerTitle: true,
      ),
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child) {
          final exercises = provider.getExercisesForWorkout(workoutDay.id);
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workoutDay.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Day: ${workoutDay.dayOfWeek}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${workoutDay.isCompleted ? 'Completed' : 'Pending'}',
                          style: TextStyle(
                            color: workoutDay.isCompleted ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Exercises list
                Text(
                  'Exercises',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                
                Expanded(
                  child: exercises.isEmpty
                      ? Center(
                          child: Text(
                            'No exercises found for this workout',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = exercises[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(exercise.name),
                                subtitle: Text(exercise.muscleGroup),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExerciseDetailScreen(exercise: exercise),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}