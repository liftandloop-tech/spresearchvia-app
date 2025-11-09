import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/config/app.config.dart';
import 'package:spresearchvia2/core/routes/app_routes.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/snackbar.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';

class ForgotMpinController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;
  final otpSent = false.obs;
  final phoneNumber = ''.obs;
  final secondsRemaining = AppConfig.OTPResendTime.obs;
  final canResend = false.obs;

  late final List<TextEditingController> otpControllers;
  late final List<FocusNode> otpFocusNodes;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    otpControllers = List.generate(4, (_) => TextEditingController());
    otpFocusNodes = List.generate(4, (_) => FocusNode());

    for (var controller in otpControllers) {
      controller.addListener(_checkOTPComplete);
    }
  }

  void _checkOTPComplete() {
    update();
  }

  bool isOTPComplete() {
    return otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  String getOTP() {
    return otpControllers.map((c) => c.text).join();
  }

  void onOTPFieldChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (otpFocusNodes[index + 1].canRequestFocus) {
          otpFocusNodes[index + 1].requestFocus();
        }
      });
    } else if (value.isEmpty && index > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (otpFocusNodes[index - 1].canRequestFocus) {
          otpFocusNodes[index - 1].requestFocus();
        }
      });
    }
  }

  Future<void> sendOTP(String phone) async {
    if (phone.isEmpty) {
      SnackbarService.showError('Please enter phone number');
      return;
    }

    try {
      isLoading.value = true;

      //

      await Future.delayed(Duration(seconds: 1));
      phoneNumber.value = phone;
      otpSent.value = true;
      _startTimer();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (otpFocusNodes[0].canRequestFocus) {
          otpFocusNodes[0].requestFocus();
        }
      });

      SnackbarService.showSuccess('OTP sent successfully to $phone');
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP() async {
    if (!isOTPComplete()) {
      SnackbarService.showError('Please enter complete OTP');
      return;
    }

    try {
      isLoading.value = true;

      final otp = getOTP();

      //

      await Future.delayed(Duration(seconds: 1));

      Get.offNamed(
        AppRoutes.setMpin,
        arguments: {'phone': phoneNumber.value, 'isReset': true},
      );
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
    } finally {
      isLoading.value = false;
    }
  }

  void resendOTP() {
    if (!canResend.value) return;

    for (var controller in otpControllers) {
      controller.clear();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (otpFocusNodes[0].canRequestFocus) {
        otpFocusNodes[0].requestFocus();
      }
    });

    _startTimer();

    sendOTP(phoneNumber.value);
  }

  void _startTimer() {
    secondsRemaining.value = AppConfig.OTPResendTime;
    canResend.value = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void reset() {
    otpSent.value = false;
    phoneNumber.value = '';
    for (var controller in otpControllers) {
      controller.clear();
    }
    _timer?.cancel();
    canResend.value = false;
    secondsRemaining.value = AppConfig.OTPResendTime;
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.removeListener(_checkOTPComplete);
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
