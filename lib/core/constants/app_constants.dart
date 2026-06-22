/// Application-wide constants for FitAI Coach
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'FitAI Coach';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // OpenAI
  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );
  static const String openAiModel = 'gpt-4o-mini';
  static const int openAiMaxTokens = 1500;

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyThemeMode = 'theme_mode';
  static const String keySubscriptionPlan = 'subscription_plan';

  // Hive Boxes
  static const String hiveBoxWorkouts = 'workouts_box';
  static const String hiveBoxNutrition = 'nutrition_box';
  static const String hiveBoxProgress = 'progress_box';
  static const String hiveBoxUser = 'user_box';

  // API Timeouts (milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;
  static const int workoutPageSize = 10;
  static const int nutritionPageSize = 15;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minAge = 13;
  static const int maxAge = 120;
  static const double minWeight = 20.0; // kg
  static const double maxWeight = 500.0; // kg
  static const double minHeight = 50.0; // cm
  static const double maxHeight = 300.0; // cm

  // AI Coach
  static const int freeAiRequestsPerDay = 3;
  static const int premiumAiRequestsPerDay = 100;

  // Subscription Plans
  static const String planFree = 'free';
  static const String planPremiumMonthly = 'premium_monthly';
  static const String planPremiumYearly = 'premium_yearly';
  static const String planLifetime = 'lifetime';

  // Subscription Prices
  static const double premiumMonthlyPrice = 4.99;
  static const double premiumYearlyPrice = 39.99;
  static const double lifetimePrice = 79.99;

  // Product IDs (In-App Purchase)
  static const String androidPremiumMonthly = 'fitai_premium_monthly';
  static const String androidPremiumYearly = 'fitai_premium_yearly';
  static const String androidLifetime = 'fitai_lifetime';
  static const String iosPremiumMonthly = 'com.fitai.coach.premium.monthly';
  static const String iosPremiumYearly = 'com.fitai.coach.premium.yearly';
  static const String iosLifetime = 'com.fitai.coach.lifetime';

  // Workout Categories
  static const String categoryBeginner = 'beginner';
  static const String categoryIntermediate = 'intermediate';
  static const String categoryAdvanced = 'advanced';

  // Meal Types
  static const String mealBreakfast = 'breakfast';
  static const String mealLunch = 'lunch';
  static const String mealDinner = 'dinner';
  static const String mealSnack = 'snack';

  // Goals
  static const String goalWeightLoss = 'weight_loss';
  static const String goalMuscleGain = 'muscle_gain';
  static const String goalMaintenance = 'maintenance';
  static const String goalGeneralFitness = 'general_fitness';

  // Activity Levels
  static const String activitySedentary = 'sedentary';
  static const String activityLightlyActive = 'lightly_active';
  static const String activityModeratelyActive = 'moderately_active';
  static const String activityVeryActive = 'very_active';
  static const String activityExtraActive = 'extra_active';

  // Activity Multipliers (Harris-Benedict)
  static const Map<String, double> activityMultipliers = {
    activitySedentary: 1.2,
    activityLightlyActive: 1.375,
    activityModeratelyActive: 1.55,
    activityVeryActive: 1.725,
    activityExtraActive: 1.9,
  };

  // Gender
  static const String genderMale = 'male';
  static const String genderFemale = 'female';
  static const String genderOther = 'other';

  // Diet Preferences
  static const String dietNone = 'none';
  static const String dietVegetarian = 'vegetarian';
  static const String dietVegan = 'vegan';
  static const String dietKeto = 'keto';
  static const String dietPaleo = 'paleo';
  static const String dietMediterranean = 'mediterranean';

  // Chart Periods
  static const String periodWeekly = 'weekly';
  static const String periodMonthly = 'monthly';
  static const String periodYearly = 'yearly';

  // Notification Channels
  static const String notifChannelWorkout = 'workout_reminders';
  static const String notifChannelNutrition = 'nutrition_reminders';
  static const String notifChannelProgress = 'progress_updates';
  static const String notifChannelGeneral = 'general';

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 100.0;
}
