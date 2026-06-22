import 'package:dartz/dartz.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/services/supabase_service.dart';
import '../models/user_model.dart';

/// User profile repository
class UserRepository {
  Future<Either<Failure, UserModel>> getUserProfile(String userId) async {
    try {
      final response = await SupabaseService.usersTable
          .select()
          .eq('id', userId)
          .single();
      return Right(UserModel.fromJson(response));
    } catch (e) {
      return Left(DatabaseFailure.fromException(DatabaseException.readError(e)));
    }
  }

  Future<Either<Failure, UserModel>> updateUserProfile(
      UserModel user) async {
    try {
      final response = await SupabaseService.usersTable
          .update(user.toJson())
          .eq('id', user.id)
          .select()
          .single();
      return Right(UserModel.fromJson(response));
    } catch (e) {
      return Left(
          DatabaseFailure.fromException(DatabaseException.writeError(e)));
    }
  }

  Future<Either<Failure, String>> uploadProfileImage({
    required String userId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    try {
      final path = '$userId/$fileName';
      await SupabaseService.profileImagesBucket.uploadBinary(
        path,
        imageBytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      final url =
          SupabaseService.profileImagesBucket.getPublicUrl(path);

      // Update user avatar_url
      await SupabaseService.usersTable
          .update({'avatar_url': url})
          .eq('id', userId);

      return Right(url);
    } catch (e) {
      return Left(StorageFailure.fromException(StorageException.uploadFailed(e)));
    }
  }
}
