import '../../core/services/supabase_service.dart';
import '../models/nutrition_model.dart';

class NutritionRemoteDatasource {
  Future<List<NutritionLogModel>> getNutritionLogs({
    required String userId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;
    final response = await SupabaseService.nutritionLogsTable
        .select()
        .eq('user_id', userId)
        .eq('date', dateStr)
        .order('created_at', ascending: true);

    return (response as List)
        .map((e) => NutritionLogModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<NutritionLogModel> addNutritionLog(NutritionLogModel log) async {
    final response = await SupabaseService.nutritionLogsTable
        .insert(log.toJson())
        .select()
        .single();
    return NutritionLogModel.fromJson(response);
  }

  Future<void> deleteNutritionLog(String logId) async {
    await SupabaseService.nutritionLogsTable.delete().eq('id', logId);
  }

  Future<NutritionLogModel> updateNutritionLog(NutritionLogModel log) async {
    final response = await SupabaseService.nutritionLogsTable
        .update(log.toJson())
        .eq('id', log.id)
        .select()
        .single();
    return NutritionLogModel.fromJson(response);
  }

  Future<double> getWaterIntake({
    required String userId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;
    final response = await SupabaseService.waterIntakeTable
        .select('amount_ml')
        .eq('user_id', userId)
        .gte('logged_at', '${dateStr}T00:00:00')
        .lte('logged_at', '${dateStr}T23:59:59');

    if ((response as List).isEmpty) return 0;
    return response.fold<double>(
        0, (sum, e) => sum + (e['amount_ml'] as num).toDouble());
  }

  Future<void> logWater({
    required String userId,
    required double amountMl,
  }) async {
    await SupabaseService.waterIntakeTable.insert({
      'user_id': userId,
      'amount_ml': amountMl,
      'logged_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get weekly calorie data for charts
  Future<List<Map<String, dynamic>>> getWeeklyCalories({
    required String userId,
    required DateTime weekStart,
  }) async {
    final endDate = weekStart.add(const Duration(days: 6));
    final response = await SupabaseService.nutritionLogsTable
        .select('date, calories')
        .eq('user_id', userId)
        .gte('date', weekStart.toIso8601String().split('T').first)
        .lte('date', endDate.toIso8601String().split('T').first);

    // Group by date
    final Map<String, double> grouped = {};
    for (final row in (response as List)) {
      final date = row['date'] as String;
      grouped[date] =
          (grouped[date] ?? 0) + (row['calories'] as num).toDouble();
    }
    return grouped.entries
        .map((e) => {'date': e.key, 'calories': e.value})
        .toList();
  }
}
