/// Route name constants for the application
abstract class AppRoutes {
  // ─── Auth Routes ──────────────────────────────────────────────────────────
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String emailVerification = '/email-verification';

  // ─── Profile Setup Routes ─────────────────────────────────────────────────
  static const String profileSetup = '/profile-setup';
  static const String goalSetup = '/goal-setup';

  // ─── Main App Routes ──────────────────────────────────────────────────────
  static const String dashboard = '/dashboard';

  // ─── Workout Routes ───────────────────────────────────────────────────────
  static const String workouts = '/workouts';
  static const String workoutDetail = '/workouts/detail';
  static const String workoutActive = '/workouts/active';
  static const String workoutComplete = '/workouts/complete';
  static const String exerciseLibrary = '/exercises';
  static const String exerciseDetail = '/exercises/detail';

  // ─── Nutrition Routes ─────────────────────────────────────────────────────
  static const String nutrition = '/nutrition';
  static const String addMeal = '/nutrition/add-meal';
  static const String mealDetail = '/nutrition/meal-detail';
  static const String foodSearch = '/nutrition/food-search';
  static const String waterTracker = '/nutrition/water';

  // ─── AI Coach Routes ──────────────────────────────────────────────────────
  static const String aiCoach = '/ai-coach';
  static const String aiMealPlan = '/ai-coach/meal-plan';
  static const String aiWorkoutPlan = '/ai-coach/workout-plan';

  // ─── Progress Routes ──────────────────────────────────────────────────────
  static const String progress = '/progress';
  static const String weightLog = '/progress/weight-log';
  static const String progressPhotos = '/progress/photos';
  static const String reports = '/progress/reports';

  // ─── Profile Routes ───────────────────────────────────────────────────────
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/profile/settings';
  static const String notifications = '/profile/notifications';
  static const String privacy = '/profile/privacy';
  static const String about = '/profile/about';

  // ─── Subscription Routes ──────────────────────────────────────────────────
  static const String subscription = '/subscription';
  static const String subscriptionSuccess = '/subscription/success';
  static const String subscriptionManage = '/subscription/manage';
}
