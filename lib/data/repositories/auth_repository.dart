import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';

/// Auth repository implementing clean architecture pattern
class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  ConnectivityService get _connectivity => Get.find<ConnectivityService>();

  AuthRepository({AuthRemoteDatasource? remoteDatasource})
      : _remoteDatasource =
            remoteDatasource ?? AuthRemoteDatasource();

  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_connectivity.isConnected.value) {
      return Left(NetworkFailure.fromException(NetworkException.noInternet()));
    }

    try {
      final user = await _remoteDatasource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!_connectivity.isConnected.value) {
      return Left(NetworkFailure.fromException(NetworkException.noInternet()));
    }

    try {
      final user = await _remoteDatasource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDatasource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    if (!_connectivity.isConnected.value) {
      return Left(NetworkFailure.fromException(NetworkException.noInternet()));
    }

    try {
      await _remoteDatasource.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    if (!_connectivity.isConnected.value) {
      return Left(NetworkFailure.fromException(NetworkException.noInternet()));
    }

    try {
      final user = await _remoteDatasource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signInWithApple() async {
    if (!_connectivity.isConnected.value) {
      return Left(NetworkFailure.fromException(NetworkException.noInternet()));
    }

    try {
      final user = await _remoteDatasource.signInWithApple();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<UserModel?> getCurrentUser() async {
    return await _remoteDatasource.getCurrentUser();
  }
}
