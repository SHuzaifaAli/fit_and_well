import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/splash_screen.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/register_screen.dart';
import '../modules/auth/views/forgot_password_screen.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_screen.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_screen.dart';
import '../modules/dashboard/views/home_screen.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_screen.dart';
import '../modules/profile/views/edit_profile_screen.dart';
import '../modules/profile/views/settings_screen.dart';
import '../modules/workouts/bindings/workout_binding.dart';
import '../modules/workouts/views/workouts_screen.dart';
import '../modules/workouts/views/workout_detail_screen.dart';
import '../modules/workouts/views/workout_active_screen.dart';
import '../modules/workouts/views/workout_complete_screen.dart';
import '../modules/workouts/views/exercise_library_screen.dart';
import '../modules/nutrition/bindings/nutrition_binding.dart';
import '../modules/nutrition/views/nutrition_screen.dart';
import '../modules/nutrition/views/add_meal_screen.dart';
import '../modules/nutrition/views/food_search_screen.dart';
import '../modules/progress/bindings/progress_binding.dart';
import '../modules/progress/views/progress_screen.dart';
import '../modules/progress/views/weight_log_screen.dart';
import '../modules/ai_coach/bindings/ai_coach_binding.dart';
import '../modules/ai_coach/views/ai_coach_screen.dart';
import '../modules/ai_coach/views/ai_meal_plan_screen.dart';
import '../modules/subscription/bindings/subscription_binding.dart';
import '../modules/subscription/views/subscription_screen.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    // ─── Auth ──────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),

    // ─── Onboarding ────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),

    // ─── Dashboard ─────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      children: [
        GetPage(
          name: AppRoutes.home,
          page: () => const HomeScreen(),
        ),
      ],
    ),

    // ─── Profile ───────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: ProfileBinding(),
    ),

    // ─── Workouts ─────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.workouts,
      page: () => const WorkoutsScreen(),
      binding: WorkoutBinding(),
    ),
    GetPage(
      name: AppRoutes.workoutDetail,
      page: () => const WorkoutDetailScreen(),
      binding: WorkoutBinding(),
    ),
    GetPage(
      name: AppRoutes.workoutActive,
      page: () => const WorkoutActiveScreen(),
      binding: WorkoutBinding(),
    ),
    GetPage(
      name: AppRoutes.activeWorkout,
      page: () => const WorkoutActiveScreen(),
      binding: WorkoutBinding(),
    ),
    GetPage(
      name: AppRoutes.workoutComplete,
      page: () => const WorkoutCompleteScreen(),
      binding: WorkoutBinding(),
    ),
    GetPage(
      name: AppRoutes.exerciseLibrary,
      page: () => const ExerciseLibraryScreen(),
      binding: WorkoutBinding(),
    ),

    // ─── Nutrition ─────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.nutrition,
      page: () => const NutritionScreen(),
      binding: NutritionBinding(),
    ),
    GetPage(
      name: AppRoutes.addMeal,
      page: () => const AddMealScreen(),
      binding: NutritionBinding(),
    ),
    GetPage(
      name: AppRoutes.foodSearch,
      page: () => const FoodSearchScreen(),
      binding: NutritionBinding(),
    ),

    // ─── Progress ──────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.progress,
      page: () => const ProgressScreen(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: AppRoutes.weightLog,
      page: () => const WeightLogScreen(),
      binding: ProgressBinding(),
    ),

    // ─── AI Coach ──────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.aiCoach,
      page: () => const AiCoachScreen(),
      binding: AiCoachBinding(),
    ),
    GetPage(
      name: AppRoutes.aiMealPlan,
      page: () => const AiMealPlanScreen(),
      binding: AiCoachBinding(),
    ),

    // ─── Subscription ──────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionScreen(),
      binding: SubscriptionBinding(),
    ),
  ];
}
