import 'package:get/get.dart';
import '../network/connectivity_service.dart';
import '../network/network_client.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';

/// Dependency injection setup using GetX
/// Registers all services and repositories
class AppInjection {
  AppInjection._();

  /// Initialize all core services
  static Future<void> init() async {
    // Core Services (Permanent - never disposed)
    await Get.putAsync<StorageService>(
      () async {
        final service = StorageService();
        await service.onInit();
        return service;
      },
      permanent: true,
    );

    Get.put<ConnectivityService>(
      ConnectivityService(),
      permanent: true,
    );

    Get.put<NetworkClient>(
      NetworkClient(),
      permanent: true,
    );
  }
}
