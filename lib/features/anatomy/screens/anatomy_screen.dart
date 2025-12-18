import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers.dart';
import '../widgets/enhanced_muscle_body_widget.dart';
import '../widgets/muscle_engagement_heatmap.dart';
import '../../../core/models.dart';
import '../../workouts/screens/exercise_detail_screen.dart';

class AnatomyScreen extends StatefulWidget {
  const AnatomyScreen({Key? key}) : super(key: key);

  @override
  State<AnatomyScreen> createState() => _AnatomyScreenState();
}

class _AnatomyScreenState extends State<AnatomyScreen> {
  String? selectedMuscleGroup;

   @override
   void initState() {
     super.initState();
     // Defer accessing ModalRoute.of(context) until the widget is mounted
     WidgetsBinding.instance.addPostFrameCallback((_) {
       final arguments = ModalRoute.of(context)?.settings.arguments;
       if (arguments is Map<String, dynamic> && arguments.containsKey('preselectMuscle')) {
         setState(() {
           selectedMuscleGroup = arguments['preselectMuscle'] as String?;
         });
       }
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background as specified
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Anatomy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Enhanced muscle body widget with SVG images
          Expanded(
            flex: 3,
            child: EnhancedMuscleBodyWidget(
              onMuscleTap: (muscleGroup) {
                setState(() {
                  selectedMuscleGroup = muscleGroup;
                });
              },
              highlightedMuscle: selectedMuscleGroup,
            ),
          ),
          
          // Exercise card with muscle engagement heatmap when muscle is selected
          if (selectedMuscleGroup != null)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF121212),
                child: Row(
                  children: [
                    // Exercise list card
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1C1C1E)
                            : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedMuscleGroup!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _buildExerciseList(selectedMuscleGroup!),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Muscle engagement heatmap
                    Expanded(
                      flex: 1,
                      child: Consumer<FitnessProvider>(
                        builder: (context, provider, child) {
                          final exercises = provider.exerciseDatabase[selectedMuscleGroup!] ?? [];
                          final exerciseNames = exercises.map((e) => e.name).toList();
                          
                          return MuscleEngagementHeatmap(
                            muscleGroup: selectedMuscleGroup!,
                            exercises: exerciseNames,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseList(String muscleGroup) {
    final provider = Provider.of<FitnessProvider>(context);
    final exercises = provider.exerciseDatabase[muscleGroup] ?? [];

    return exercises.isEmpty
        ? Center(
            child: Text(
              'No exercises found for $muscleGroup',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              ),
            ),
          )
        : ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  title: Text(
                    exercise.name,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    exercise.description,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // Navigate to exercise detail screen
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
          );
  }

  void _showExerciseDetail(Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${exercise.description}'),
            const SizedBox(height: 8),
            Text('Equipment: ${exercise.equipmentNeeded}'),
            const SizedBox(height: 8),
            Text('Difficulty: ${exercise.difficultyLevel}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}