import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/workout_remote_datasource.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  final WorkoutRemoteDatasource _datasource;

  WorkoutRepository({WorkoutRemoteDatasource? datasource})
      : _datasource = datasource ?? WorkoutRemoteDatasource();

  Future<Either<Failure, List<WorkoutModel>>> getWorkouts({
    String? difficulty,
    String? category,
    int page = 0,
  }) async {
    try {
      final workouts = await _datasource.getWorkouts(
        difficulty: difficulty,
        category: category,
        page: page,
      );
      return Right(workouts);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }

  Future<Either<Failure, WorkoutModel>> getWorkoutById(
      String workoutId) async {
    try {
      final workout = await _datasource.getWorkoutById(workoutId);
      return Right(workout);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }

  Future<Either<Failure, UserWorkoutModel>> logWorkout({
    required String userId,
    required String workoutId,
    required String status,
    int? durationMinutes,
    int? caloriesBurned,
  }) async {
    try {
      final log = await _datasource.logWorkout(
        userId: userId,
        workoutId: workoutId,
        status: status,
        durationMinutes: durationMinutes,
        caloriesBurned: caloriesBurned,
      );
      return Right(log);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.writeError(e)));
    }
  }

  Future<Either<Failure, List<UserWorkoutModel>>> getUserWorkoutHistory({
    required String userId,
    int page = 0,
  }) async {
    try {
      final history = await _datasource.getUserWorkoutHistory(
        userId: userId,
        page: page,
      );
      return Right(history);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }

  Future<Either<Failure, int>> getWorkoutStreak(String userId) async {
    try {
      final streak = await _datasource.getWorkoutStreak(userId);
      return Right(streak);
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }
}
