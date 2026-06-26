// ============================================================
// STUB SCREENS — lib/modules/*/views/
// These satisfy app_pages.dart route imports until their
// respective phases are implemented.
// Each file should be broken out into its own path as shown.
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Workouts ─────────────────────────────────────────────────────────────────
// lib/modules/workouts/views/

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Workouts', tag: 'Phase 3');
}

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Workout Detail', tag: 'Phase 3');
}

class WorkoutActiveScreen extends StatelessWidget {
  const WorkoutActiveScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Active Workout', tag: 'Phase 3');
}

class WorkoutCompleteScreen extends StatelessWidget {
  const WorkoutCompleteScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Workout Complete', tag: 'Phase 3');
}

class ExerciseLibraryScreen extends StatelessWidget {
  const ExerciseLibraryScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Exercise Library', tag: 'Phase 3');
}

// lib/modules/workouts/bindings/
class WorkoutBinding extends Bindings {
  @override
  void dependencies() {}
}

// ─── Nutrition ────────────────────────────────────────────────────────────────
// lib/modules/nutrition/views/

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Nutrition', tag: 'Phase 4');
}

class AddMealScreen extends StatelessWidget {
  const AddMealScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Add Meal', tag: 'Phase 4');
}

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Food Search', tag: 'Phase 4');
}

// lib/modules/nutrition/bindings/
class NutritionBinding extends Bindings {
  @override
  void dependencies() {}
}

// ─── AI Coach ─────────────────────────────────────────────────────────────────
// lib/modules/ai_coach/views/

class AiCoachScreen extends StatelessWidget {
  const AiCoachScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'AI Coach', tag: 'Phase 5');
}

class AiMealPlanScreen extends StatelessWidget {
  const AiMealPlanScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'AI Meal Plan', tag: 'Phase 5');
}

// lib/modules/ai_coach/bindings/
class AiCoachBinding extends Bindings {
  @override
  void dependencies() {}
}

// ─── Progress ─────────────────────────────────────────────────────────────────
// lib/modules/progress/views/

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Progress', tag: 'Phase 6');
}

class WeightLogScreen extends StatelessWidget {
  const WeightLogScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Weight Log', tag: 'Phase 6');
}

// lib/modules/progress/bindings/
class ProgressBinding extends Bindings {
  @override
  void dependencies() {}
}

// ─── Profile ──────────────────────────────────────────────────────────────────
// lib/modules/profile/views/

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Profile', tag: 'Phase 2');
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Edit Profile', tag: 'Phase 2');
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Settings', tag: 'Phase 2');
}

// lib/modules/profile/bindings/
class ProfileBinding extends Bindings {
  @override
  void dependencies() {}
}

// ─── Subscription ─────────────────────────────────────────────────────────────
// lib/modules/subscription/views/

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});
  @override
  Widget build(BuildContext context) => _StubScreen(title: 'Subscription', tag: 'Phase 8');
}

// lib/modules/subscription/bindings/
class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {}
}

// ─── Shared Stub Widget ───────────────────────────────────────────────────────

class _StubScreen extends StatelessWidget {
  final String title;
  final String tag;

  const _StubScreen({required this.title, required this.tag});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF222222) : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.construction_rounded,
                size: 36,
                color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming in $tag',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
