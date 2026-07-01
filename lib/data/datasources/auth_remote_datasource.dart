import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/errors/app_exceptions.dart' as AuthExceptions;
import '../../core/services/supabase_service.dart';
import '../models/user_model.dart';

/// Remote data source for authentication operations
class AuthRemoteDatasource {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // ─── Email/Password Auth ──────────────────────────────────────────────────

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (response.user == null) {
        throw AuthExceptions.AuthException.invalidCredentials();
      }

      return await _fetchOrCreateUserProfile(response.user!);
    } on AuthException {
      rethrow;
    } on AuthExceptions.AuthException catch (e) {
      throw _mapSupabaseAuthError(e.toString());
    } catch (e) {
      if (e.toString().contains('Invalid login credentials')) {
        throw AuthExceptions.AuthException.invalidCredentials();
      }
      if (e.toString().contains('Email not confirmed')) {
        throw AuthExceptions.AuthException.emailNotVerified();
      }
      throw AuthExceptions.AuthException.unknown(e);
    }
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await SupabaseService.auth.signUp(
        email: email.trim().toLowerCase(),
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw AuthExceptions.AuthException.unknown();
      }

      // Create user profile in database
      await _createUserProfile(
        userId: response.user!.id,
        email: email.trim().toLowerCase(),
        name: name,
      );

      return UserModel(
        id: response.user!.id,
        email: email.trim().toLowerCase(),
        name: name,
        createdAt: DateTime.now(),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('already registered')) {
        throw AuthExceptions.AuthException.emailAlreadyInUse();
      }
      if (e.toString().contains('Password should be')) {
        throw AuthExceptions.AuthException.weakPassword();
      }
      throw AuthExceptions.AuthException.unknown(e);
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseService.auth.signOut();
    } catch (e) {
      throw AuthExceptions.AuthException.unknown(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await SupabaseService.auth.resetPasswordForEmail(
        email.trim().toLowerCase(),
      );
    } catch (e) {
      throw AuthExceptions.AuthException.unknown(e);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await SupabaseService.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw AuthExceptions.AuthException.unknown(e);
    }
  }

  // ─── Google Sign In ───────────────────────────────────────────────────────

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthExceptions.AuthException.googleSignInFailed('User cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw AuthExceptions.AuthException.googleSignInFailed('Missing tokens');
      }

      final response = await SupabaseService.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw AuthExceptions.AuthException.googleSignInFailed();
      }

      return await _fetchOrCreateUserProfile(
        response.user!,
        displayName: googleUser.displayName,
        avatarUrl: googleUser.photoUrl,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptions.AuthException.googleSignInFailed(e);
    }
  }

  // ─── Apple Sign In ────────────────────────────────────────────────────────

  Future<UserModel> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw AuthExceptions.AuthException.appleSignInFailed('Missing identity token');
      }

      final response = await SupabaseService.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
      );

      if (response.user == null) {
        throw AuthExceptions.AuthException.appleSignInFailed();
      }

      final name = [
        credential.givenName,
        credential.familyName,
      ].where((e) => e != null).join(' ');

      return await _fetchOrCreateUserProfile(
        response.user!,
        displayName: name.isNotEmpty ? name : null,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthExceptions.AuthException.appleSignInFailed(e);
    }
  }

  // ─── Session Management ───────────────────────────────────────────────────

  Future<UserModel?> getCurrentUser() async {
    final user = SupabaseService.currentUser;
    if (user == null) return null;

    try {
      return await _fetchUserProfile(user.id);
    } catch (_) {
      return null;
    }
  }

  Stream<AuthState> get authStateChanges =>
      SupabaseService.authStateChanges;

  // ─── Private Helpers ──────────────────────────────────────────────────────

  Future<UserModel> _fetchOrCreateUserProfile(
    User user, {
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      return await _fetchUserProfile(user.id);
    } catch (_) {
      // Profile doesn't exist, create it
      final name = displayName ??
          user.userMetadata?['name'] as String? ??
          user.email?.split('@').first ??
          'User';

      await _createUserProfile(
        userId: user.id,
        email: user.email ?? '',
        name: name,
        avatarUrl: avatarUrl,
      );

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        name: name,
        avatarUrl: avatarUrl,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<UserModel> _fetchUserProfile(String userId) async {
    final response = await SupabaseService.usersTable
        .select()
        .eq('id', userId)
        .single();

    return UserModel.fromJson(response);
  }

  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String name,
    String? avatarUrl,
  }) async {
    await SupabaseService.usersTable.insert({
      'id': userId,
      'email': email,
      'name': name,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'subscription_plan': 'free',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  AuthExceptions.AuthException _mapSupabaseAuthError(String error) {
    if (error.contains('Invalid login credentials')) {
      return AuthExceptions.AuthException.invalidCredentials();
    }
    if (error.contains('User already registered')) {
      return AuthExceptions.AuthException.emailAlreadyInUse();
    }
    if (error.contains('Password should be')) {
      return AuthExceptions.AuthException.weakPassword();
    }
    if (error.contains('Email not confirmed')) {
      return AuthExceptions.AuthException.emailNotVerified();
    }
    return AuthExceptions.AuthException.unknown(error);
  }
}
