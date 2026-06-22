import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';

/// Secure and regular storage service
/// Uses FlutterSecureStorage for sensitive data (tokens, keys)
/// Uses SharedPreferences for non-sensitive preferences
class StorageService extends GetxService {
  late final FlutterSecureStorage _secureStorage;
  late final SharedPreferences _prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> _initialize() async {
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
    _prefs = await SharedPreferences.getInstance();
  }

  // ─── Secure Storage (Tokens, Keys) ───────────────────────────────────────

  Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAllSecure() async {
    await _secureStorage.deleteAll();
  }

  // ─── Token Management ─────────────────────────────────────────────────────

  Future<void> saveAccessToken(String token) async {
    await saveSecure(AppConstants.keyAccessToken, token);
  }

  Future<String?> getAccessToken() async {
    return await readSecure(AppConstants.keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await saveSecure(AppConstants.keyRefreshToken, token);
  }

  Future<String?> getRefreshToken() async {
    return await readSecure(AppConstants.keyRefreshToken);
  }

  Future<void> clearTokens() async {
    await deleteSecure(AppConstants.keyAccessToken);
    await deleteSecure(AppConstants.keyRefreshToken);
  }

  // ─── Regular Storage (Preferences) ───────────────────────────────────────

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) => _prefs.getString(key);

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) => _prefs.getInt(key);

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) => _prefs.getDouble(key);

  Future<void> setObject(String key, Map<String, dynamic> value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getObject(String key) {
    final str = _prefs.getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // ─── App-Specific Helpers ─────────────────────────────────────────────────

  bool get isOnboardingComplete =>
      getBool(AppConstants.keyOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete(bool value) async {
    await setBool(AppConstants.keyOnboardingComplete, value);
  }

  String get themeMode => getString(AppConstants.keyThemeMode) ?? 'system';

  Future<void> setThemeMode(String mode) async {
    await setString(AppConstants.keyThemeMode, mode);
  }

  String get subscriptionPlan =>
      getString(AppConstants.keySubscriptionPlan) ?? AppConstants.planFree;

  Future<void> setSubscriptionPlan(String plan) async {
    await setString(AppConstants.keySubscriptionPlan, plan);
  }
}
