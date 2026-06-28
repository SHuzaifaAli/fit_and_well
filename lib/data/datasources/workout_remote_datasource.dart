import '../../core/services/supabase_service.dart';
import '../models/workout_model.dart';

class WorkoutRemoteDatasource {
  /// Fetch all workouts, optionally filtered by difficulty
  Future<List<WorkoutModel>> getWorkouts({
    String? difficulty,
    String? category,
    int page = 0,
    int pageSize = 20,
  }) async {
    var query = SupabaseService.workoutsTable
        .select('*, exercises(*)')
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .range(page * pageSize, (page + 1) * pageSize - 1);

    if (difficulty != null) {
      query = query.eq('difficulty', difficulty) as dynamic;
    }

    final response = await query;
    return (response as List)
        .map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single workout with its exercises
  Future<WorkoutModel> getWorkoutById(String workoutId) async {
    final response = await SupabaseService.workoutsTable
        .select('*, exercises(*)')
        .eq('id', workoutId)
        .single();
    return WorkoutModel.fromJson(response);
  }

  /// Log a completed workout for a user
  Future<UserWorkoutModel> logWorkout({
    required String userId,
    required String workoutId,
    required String status,
    int? durationMinutes,
    int? caloriesBurned,
  }) async {
    final data = {
      'user_id': userId,
      'workout_id': workoutId,
      'status': status,
      if (status == 'completed') 'completed_at': DateTime.now().toIso8601String(),
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      'created_at': DateTime.now().toIso8601String(),
    };

    final response = await SupabaseService.userWorkoutsTable
        .insert(data)
        .select()
        .single();
    return UserWorkoutModel.fromJson(response);
  }

  /// Get user's workout history
  Future<List<UserWorkoutModel>> getUserWorkoutHistory({
    required String userId,
    int page = 0,
    int pageSize = 20,
  }) async {
    final response = await SupabaseService.userWorkoutsTable
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(page * pageSize, (page + 1) * pageSize - 1);

    return (response as List)
        .map((e) => UserWorkoutModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get workout streak for a user
  Future<int> getWorkoutStreak(String userId) async {
    final response = await SupabaseService.userWorkoutsTable
        .select('completed_at')
        .eq('user_id', userId)
        .eq('status', 'completed')
        .order('completed_at', ascending: false)
        .limit(60);

    if ((response as List).isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    final dates = response
        .map((e) => DateTime.parse(e['completed_at'] as String))
        .toSet()
        .map((d) => DateTime(d.year, d.month, d.day))
        .toList()
      ..sort((a, b) => b.compareTo(a));

    for (final date in dates) {
      final expected = DateTime(
          checkDate.year, checkDate.month, checkDate.day);
      if (date == expected || date == expected.subtract(const Duration(days: 1))) {
        streak++;
        checkDate = date;
      } else {
        break;
      }
    }

    return streak;
  }
}
