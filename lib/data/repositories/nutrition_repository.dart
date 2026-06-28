import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/nutrition_remote_datasource.dart';
import '../models/nutrition_model.dart';

class NutritionRepository {
  final NutritionRemoteDatasource _datasource;

  NutritionRepository({NutritionRemoteDatasource? datasource})
      : _datasource = datasource ?? NutritionRemoteDatasource();

  Future<Either<Failure, List<NutritionLogModel>>> getNutritionLogs({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final logs = await _datasource.getNutritionLogs(
          userId: userId, date: date);
      return Right(logs);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }

  Future<Either<Failure, NutritionLogModel>> addNutritionLog(
      NutritionLogModel log) async {
    try {
      final result = await _datasource.addNutritionLog(log);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.writeError(e)));
    }
  }

  Future<Either<Failure, void>> deleteNutritionLog(String logId) async {
    try {
      await _datasource.deleteNutritionLog(logId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.writeError(e)));
    }
  }

  Future<Either<Failure, double>> getWaterIntake({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final ml = await _datasource.getWaterIntake(
          userId: userId, date: date);
      return Right(ml);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }

  Future<Either<Failure, void>> logWater({
    required String userId,
    required double amountMl,
  }) async {
    try {
      await _datasource.logWater(userId: userId, amountMl: amountMl);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.writeError(e)));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getWeeklyCalories({
    required String userId,
    required DateTime weekStart,
  }) async {
    try {
      final data = await _datasource.getWeeklyCalories(
          userId: userId, weekStart: weekStart);
      return Right(data);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }
}
