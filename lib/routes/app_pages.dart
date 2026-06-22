import 'package:get/get.dart';
import 'app_routes.dart';

// Auth
import '../modules/auth/views/splash_screen.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/register_screen.dart';
import '../modules/auth/views/forgot_password_screen.dart';
import '../modules/auth/bindings/auth_binding.dart';

// Onboarding
import '../modules/onboarding/views/onboarding_screen.dart';
import '../modules/onboarding/views/profile_setup_screen.dart';
import '../modules/onboarding/views/goal_setup_screen.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';

// Dashboard
import '../modules/dashboard/views/dashboard_screen.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';

// Workouts
import '../modules/workouts/views/workouts_screen.dart';
import '../modules/workouts/views/workout_detail_screen.dart';
import '../modules/workouts/views/workout_active_screen.dart';
import '../modules/workouts/views/workout_complete_screen.dart';
import '../modules/workouts/views/exercise_library_screen.dart';
import '../modules/workouts/bindings/workout_binding.dart';

// Nutrition
import '../modules/nutrition/views/nutrition_screen.dart';
import '../modules/nutrition/views/add_meal_screen.dart';
import '../modules/nutrition/views/food_search_screen.dart';
import '../modules/nutrition/bindings/nutrition_binding.dart';

// AI Coach
import '../modules/ai_coach/views/ai_coach_screen.dart';
import '../modules/ai_coach/views/ai_meal_plan_screen.dart';
import '../modules/ai_coach/bindings/ai_coach_binding.dart';

// Progress
import '../modules/progress/views/progress_screen.dart';
import '../modules/progress/views/weight_log_screen.dart';
import '../modules/progress/bindings/progress_binding.dart';

// Profile
import '../modules/profile/views/profile_screen.dart';
import '../modules/profile/views/edit_profile_screen.dart';
import '../modules/profile/views/settings_screen.dart';
import '../modules/profile/bindings/profile_binding.dart';

// Subscription
import '../modules/subscription/views/subscription_screen.dart';
import '../modules/subscription/bindings/subscription_binding.dart';

/// GetX pages configuration - maps routes to screens and bindings
class AppPages {
  AppPages._();

  static const String initial = AppRoutes.splash;

  static final List<GetPage> pages = [
    // ─── Auth ──────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── Profile Setup ─────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.profileSetup,
      page: () => const ProfileSetupScreen(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.goalSetup,
      page: () => const GoalSetupScreen(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── Dashboard ─────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
    ),

    // ─── Workouts ──────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.workouts,
      page: () => const WorkoutsScreen(),
      binding: WorkoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.workoutDetail,
      page: () => const WorkoutDetailScreen(),
      binding: WorkoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.workoutActive,
      page: () => const WorkoutActiveScreen(),
      binding: WorkoutBinding(),
      transition: Transition.upToDown,
    ),
    GetPage(
      name: AppRoutes.workoutComplete,
      page: () => const WorkoutCompleteScreen(),
      binding: WorkoutBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRoutes.exerciseLibrary,
      page: () => const ExerciseLibraryScreen(),
      binding: WorkoutBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── Nutrition ─────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.nutrition,
      page: () => const NutritionScreen(),
      binding: NutritionBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addMeal,
      page: () => const AddMealScreen(),
      binding: NutritionBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.foodSearch,
      page: () => const FoodSearchScreen(),
      binding: NutritionBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── AI Coach ──────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.aiCoach,
      page: () => const AiCoachScreen(),
      binding: AiCoachBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.aiMealPlan,
      page: () => const AiMealPlanScreen(),
      binding: AiCoachBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── Progress ──────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.progress,
      page: () => const ProgressScreen(),
      binding: ProgressBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.weightLog,
      page: () => const WeightLogScreen(),
      binding: ProgressBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── Profile ───────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── Subscription ──────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionScreen(),
      binding: SubscriptionBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
