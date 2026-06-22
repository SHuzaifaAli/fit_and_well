import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

/// Supabase service wrapper providing typed access to Supabase client
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseStorageClient get storage => client.storage;

  static RealtimeClient get realtime => client.realtime;

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      debug: false,
    );
  }

  /// Get current user
  static User? get currentUser => auth.currentUser;

  /// Get current session
  static Session? get currentSession => auth.currentSession;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Get current user ID
  static String? get currentUserId => currentUser?.id;

  /// Stream of auth state changes
  static Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ─── Table References ─────────────────────────────────────────────────────

  static SupabaseQueryBuilder get usersTable => client.from('users');
  static SupabaseQueryBuilder get workoutsTable => client.from('workouts');
  static SupabaseQueryBuilder get exercisesTable => client.from('exercises');
  static SupabaseQueryBuilder get userWorkoutsTable =>
      client.from('user_workouts');
  static SupabaseQueryBuilder get nutritionLogsTable =>
      client.from('nutrition_logs');
  static SupabaseQueryBuilder get weightLogsTable =>
      client.from('weight_logs');
  static SupabaseQueryBuilder get subscriptionsTable =>
      client.from('subscriptions');
  static SupabaseQueryBuilder get aiRequestsTable =>
      client.from('ai_requests');

  // ─── Storage Buckets ──────────────────────────────────────────────────────

  static SupabaseStorageBucketApi get profileImagesBucket =>
      storage.from('profile_images');
  static SupabaseStorageBucketApi get workoutImagesBucket =>
      storage.from('workout_images');
  static SupabaseStorageBucketApi get exerciseVideosBucket =>
      storage.from('exercise_videos');
}
