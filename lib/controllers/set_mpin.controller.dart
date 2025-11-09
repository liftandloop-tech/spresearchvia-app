import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/routes/app_routes.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/snackbar.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';

class SetMpinController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;
  final phoneNumber = ''.obs;
  final isReset = false.obs;

  late final List<TextEditingController> mpinControllers;
  late final List<FocusNode> mpinFocusNodes;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      phoneNumber.value = args['phone'] ?? '';
      isReset.value = args['isReset'] ?? false;
    }

    mpinControllers = List.generate(4, (_) => TextEditingController());
    mpinFocusNodes = List.generate(4, (_) => FocusNode());

    for (var controller in mpinControllers) {
      controller.addListener(_checkMPINComplete);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mpinFocusNodes[0].canRequestFocus) {
        mpinFocusNodes[0].requestFocus();
      }
    });
  }

  void _checkMPINComplete() {
    update();
  }

  bool isMPINComplete() {
    return mpinControllers.every((controller) => controller.text.isNotEmpty);
  }

  String getMPIN() {
    return mpinControllers.map((c) => c.text).join();
  }

  void onMPINFieldChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mpinFocusNodes[index + 1].canRequestFocus) {
          mpinFocusNodes[index + 1].requestFocus();
        }
      });
    } else if (value.isEmpty && index > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mpinFocusNodes[index - 1].canRequestFocus) {
          mpinFocusNodes[index - 1].requestFocus();
        }
      });
    }
  }

  Future<void> setMPIN() async {
    if (!isMPINComplete()) {
      SnackbarService.showError('Please enter complete MPIN');
      return;
    }

    try {
      isLoading.value = true;

      final mpin = getMPIN();

      //

      //

      await Future.delayed(Duration(seconds: 1));

      SnackbarService.showSuccess(
        isReset.value
            ? 'MPIN reset successfully! You can now login with your new MPIN.'
            : 'MPIN set successfully!',
      );

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (var controller in mpinControllers) {
      controller.removeListener(_checkMPINComplete);
      controller.dispose();
    }
    for (var node in mpinFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
