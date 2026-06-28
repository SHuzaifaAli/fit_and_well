import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/progress_remote_datasource.dart';
import '../models/progress_model.dart';

class ProgressRepository {
  final ProgressRemoteDatasource _datasource;

  ProgressRepository({ProgressRemoteDatasource? datasource})
      : _datasource = datasource ?? ProgressRemoteDatasource();

  Future<Either<Failure, List<WeightLogModel>>> getWeightLogs({
    required String userId,
    int limit = 30,
  }) async {
    try {
      final logs =
          await _datasource.getWeightLogs(userId: userId, limit: limit);
      return Right(logs);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }

  Future<Either<Failure, WeightLogModel>> addWeightLog(
      WeightLogModel log) async {
    try {
      final result = await _datasource.addWeightLog(log);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.writeError(e)));
    }
  }

  Future<Either<Failure, void>> deleteWeightLog(String logId) async {
    try {
      await _datasource.deleteWeightLog(logId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.writeError(e)));
    }
  }

  Future<Either<Failure, int>> getTotalWorkoutsCompleted(
      String userId) async {
    try {
      final count =
          await _datasource.getTotalWorkoutsCompleted(userId);
      return Right(count);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }
}
