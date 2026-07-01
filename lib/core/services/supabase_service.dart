import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => client.auth;
  static SupabaseStorageClient get storage => client.storage;
  static RealtimeClient get realtime => client.realtime;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,  // ✅ fixed deprecation
      debug: false,
    );
  }

  static User? get currentUser => auth.currentUser;
  static Session? get currentSession => auth.currentSession;
  static bool get isAuthenticated => currentUser != null;
  static String? get currentUserId => currentUser?.id;
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
  static SupabaseQueryBuilder get waterIntakeTable =>
      client.from('water_intake');
  static SupabaseQueryBuilder get aiRequestsTable =>
      client.from('ai_requests');

  // ─── Storage Buckets ──────────────────────────────────────────────────────

  // Instead of `static StorageBucketApi get ...`
  static get profileImagesBucket => storage.from('profile_images');
  static get workoutImagesBucket => storage.from('workout_images');
  static get exerciseVideosBucket => storage.from('exercise_videos');
}