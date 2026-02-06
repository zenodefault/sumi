import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HabitDialogHelper {
  static void showAddHabitBottomSheet({
    required BuildContext context,
    required Function(Habit) onHabitAdded,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Health';
    String selectedPriority = 'Medium';
    bool isDaily = true;
    final categories = <String>[
      'Health',
      'Fitness',
      'Mindfulness',
      'Productivity',
    ];
    final priorities = <String>['High', 'Medium', 'Low'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final theme = Theme.of(context);
          final isLight = theme.brightness == Brightness.light;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Add New Habit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name field
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Habit name',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a habit name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Description field
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: categories
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: selectedPriority,
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: priorities
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedPriority = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: isDaily ? 'Daily' : 'Weekly',
                        decoration: InputDecoration(
                          labelText: 'Frequency',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'Weekly',
                            child: Text('Weekly'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              isDaily = value == 'Daily';
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      const SizedBox(height: 8),

                      // Submit button
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final newHabit = Habit(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              name: nameController.text,
                              description: descriptionController.text,
                              category: selectedCategory,
                              priority: selectedPriority,
                              isDaily: isDaily,
                              reminderTime: '08:00',
                              startDate: DateTime.now(),
                            );

                            onHabitAdded(newHabit);

                            Navigator.pop(context);

                            // Show success snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Habit added successfully!',
                                ),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Add Habit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static void showEditHabitBottomSheet({
    required BuildContext context,
    required Habit habit,
    required Function(Habit) onHabitUpdated,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: habit.name);
    final descriptionController = TextEditingController(
      text: habit.description,
    );
    String selectedCategory = habit.category;
    String selectedPriority = habit.priority;
    bool isDaily = habit.isDaily;
    final categories = <String>[
      'Health',
      'Fitness',
      'Mindfulness',
      'Productivity',
    ];
    final priorities = <String>['High', 'Medium', 'Low'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final theme = Theme.of(context);
          final isLight = theme.brightness == Brightness.light;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Edit Habit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Habit name',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a habit name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: categories
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedPriority,
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: priorities
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedPriority = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: isDaily ? 'Daily' : 'Weekly',
                        decoration: InputDecoration(
                          labelText: 'Frequency',
                          filled: true,
                          fillColor: (isLight ? Colors.black : Colors.white)
                              .withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'Weekly',
                            child: Text('Weekly'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              isDaily = value == 'Daily';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final updatedHabit = habit.copyWith(
                              name: nameController.text,
                              description: descriptionController.text,
                              category: selectedCategory,
                              priority: selectedPriority,
                              isDaily: isDaily,
                              reminderTime: habit.reminderTime,
                            );

                            onHabitUpdated(updatedHabit);

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Habit updated successfully!',
                                ),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Update Habit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required Habit habit,
    required Function(String) onHabitDeleted,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Delete Habit',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete "${habit.name}"?',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              onHabitDeleted(habit.id);

              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Habit deleted successfully!'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  
}
