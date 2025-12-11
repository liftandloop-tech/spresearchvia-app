import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth.controller.dart';
import 'controllers/user.controller.dart';
import 'controllers/kyc.controller.dart';
import 'controllers/plan_purchase.controller.dart';
import 'controllers/report.controller.dart';
import 'services/secure_storage.service.dart';
import 'services/payment.service.dart';
import 'services/snackbar.service.dart';
import 'core/routes/app_routes.dart';
import 'core/config/app.config.dart';

Future<void> startup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SecureStorageService.init();

  Get.put(SecureStorageService(), permanent: true);
  Get.put(PaymentService(), permanent: true);

  Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  Get.lazyPut<UserController>(() => UserController(), fenix: true);
  Get.lazyPut<KycController>(() => KycController(), fenix: true);
  Get.lazyPut<PlanPurchaseController>(
    () => PlanPurchaseController(),
    fenix: true,
  );
  Get.lazyPut<ReportController>(() => ReportController(), fenix: true);

  if (AppConfig.isProduction) {
    final authController = Get.find<AuthController>();
    await authController.checkAuthStatus();

    await _checkPendingPayments();
  }
}

Future<void> _checkPendingPayments() async {
  try {
    final secureStorage = Get.find<SecureStorageService>();
    final pending = await secureStorage.getPendingPayment();

    if (pending != null) {
      final paymentId = pending['paymentId'];
      final orderId = pending['orderId'];

      if (Get.isRegistered<PlanPurchaseController>()) {
        final planController = Get.find<PlanPurchaseController>();

        final success = await planController.verifyPayment(
          paymentId: paymentId!,
          razorpayOrderId: orderId!,
          razorpayPaymentId: paymentId,
          razorpaySignature: '',
        );

        if (success) {
          await secureStorage.clearPendingPayment();
          SnackbarService.showSuccess(
            'Previous payment verified successfully!',
          );

          await Future.delayed(const Duration(milliseconds: 1000));
          Get.offAllNamed(AppRoutes.tabs);
        }
      }
    }
  } catch (e) {
    // Ignore pending payment check errors
  }
}
