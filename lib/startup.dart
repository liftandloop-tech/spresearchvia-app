import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth.controller.dart';
import 'controllers/user.controller.dart';
import 'controllers/kyc.controller.dart';
import 'controllers/plan_purchase.controller.dart';
import 'controllers/report.controller.dart';
import 'services/secure_storage.service.dart';
import 'services/payment.service.dart';
import 'core/config/app.config.dart';

Future<void> startup() async {
  await WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await SecureStorageService.init();

  // Initialize core services
  Get.put(SecureStorageService(), permanent: true);
  Get.put(PaymentService(), permanent: true);

  // Use lazyPut for controllers - instantiated only when first accessed
  Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  Get.lazyPut<UserController>(() => UserController(), fenix: true);
  Get.lazyPut<KycController>(() => KycController(), fenix: true);
  Get.lazyPut<PlanPurchaseController>(() => PlanPurchaseController(), fenix: true);
  Get.lazyPut<ReportController>(() => ReportController(), fenix: true);

  // Preload critical data in production
  if (AppConfig.isProduction) {
    final authController = Get.find<AuthController>();
    await authController.checkAuthStatus();
  }
}