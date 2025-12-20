import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth.controller.dart';
import '../core/routes/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../services/snackbar.service.dart';
import '../services/secure_storage.service.dart';
import '../core/utils/validators.dart';

class LoginController extends GetxController {
  final authController = Get.find<AuthController>();
  final phoneOrMailController = TextEditingController();
  final mpinController = TextEditingController();
  final isLoading = false.obs;
  final _storage = SecureStorageService();

  @override
  void onInit() {
    super.onInit();
    authController.resetOtpState();

    Future.microtask(_prefillFromStorage);
  }

  Future<void> _prefillFromStorage() async {
    try {
      final userData = await _storage.getUserData();
      if (userData != null) {
        final String? phone = userData['phone'] as String?;
        final String? email = userData['email'] as String?;

        if (phone != null && phone.isNotEmpty) {
          final normalized = phone.startsWith('91') && phone.length == 12
              ? phone.substring(2)
              : phone;
          phoneOrMailController.text = normalized;
        } else if (email != null && email.isNotEmpty) {
          phoneOrMailController.text = email;
        }

        mpinController.clear();
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    phoneOrMailController.dispose();
    mpinController.dispose();
    super.onClose();
  }

  Future<void> handleLogin() async {
    final String input = phoneOrMailController.text.trim();
    final String mpin = mpinController.text.trim();

    if (input.isEmpty || mpin.isEmpty) {
      SnackbarService.showError(AppStrings.pleaseEnterCredentials);
      return;
    }

    if (mpin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(mpin)) {
      SnackbarService.showError('MPIN must be exactly 4 digits');
      return;
    }

    final bool isPhone = RegExp(r'^\d{10}$').hasMatch(input);
    final bool isEmail = !isPhone && Validators.isValidEmail(input);

    if (!isEmail && !isPhone) {
      SnackbarService.showError('Enter valid 10-digit phone or email');
      return;
    }

    final String processedInput = isPhone ? '91$input' : input.toUpperCase();

    isLoading.value = true;

    try {
      final success = await authController.login(
        email: isEmail ? processedInput : null,
        phone: isPhone ? processedInput : null,
        mPin: mpin,
      );

      if (success) {
        await _storage.clearSubscriptionCache();
        final hasSubscription = await authController.hasActiveSubscription(
          forceRefresh: true,
        );
        if (hasSubscription) {
          SnackbarService.showSuccess('Login successful!');
          Get.offAllNamed(AppRoutes.tabs);
        } else {
          SnackbarService.showWarning(
            'No active subscription found, please register to continue',
          );
          Get.offAllNamed(AppRoutes.registrationScreen);
        }
      } else {
        SnackbarService.showError('Invalid credentials. Please try again.');
      }
    } catch (e) {
      SnackbarService.showError('Login failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
