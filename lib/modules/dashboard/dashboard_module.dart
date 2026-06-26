// ============================================================
// DASHBOARD MODULE — lib/modules/dashboard/
// ============================================================

// ── binding ──────────────────────────────────────────────────
// lib/modules/dashboard/bindings/dashboard_binding.dart

import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

// ============================================================

// ── controller ───────────────────────────────────────────────
// lib/modules/dashboard/controllers/dashboard_controller.dart

class DashboardController extends GetxController {
  AuthController get _auth => Get.find<AuthController>();

  final RxInt selectedIndex = 0.obs;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get userName =>
      _auth.currentUser.value?.name.split(' ').first ?? 'there';
}
