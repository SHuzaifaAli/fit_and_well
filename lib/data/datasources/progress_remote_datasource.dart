import '../../core/services/supabase_service.dart';
import '../models/progress_model.dart';

class ProgressRemoteDatasource {
  Future<List<WeightLogModel>> getWeightLogs({
    required String userId,
    int limit = 30,
  }) async {
    final response = await SupabaseService.weightLogsTable
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false)
        .limit(limit);

    return (response as List)
        .map((e) => WeightLogModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WeightLogModel> addWeightLog(WeightLogModel log) async {
    final response = await SupabaseService.weightLogsTable
        .insert(log.toJson())
        .select()
        .single();
    return WeightLogModel.fromJson(response);
  }

  Future<void> deleteWeightLog(String logId) async {
    await SupabaseService.weightLogsTable.delete().eq('id', logId);
  }

  Future<WeightLogModel?> getLatestWeightLog(String userId) async {
    final response = await SupabaseService.weightLogsTable
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false)
        .limit(1);

    if ((response as List).isEmpty) return null;
    return WeightLogModel.fromJson(response.first as Map<String, dynamic>);
  }

  Future<int> getTotalWorkoutsCompleted(String userId) async {
    final response = await SupabaseService.userWorkoutsTable
        .select('id')
        .eq('user_id', userId)
        .eq('status', 'completed');
    return (response as List).length;
  }
}
