// Re-export WorkoutListScreen under the name WorkoutsScreen
// to match the route reference in app_pages.dart
export 'workout_list_screen.dart' show WorkoutListScreen;

// Provide a named alias
import 'package:flutter/material.dart';
import 'workout_list_screen.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) => const WorkoutListScreen();
}
