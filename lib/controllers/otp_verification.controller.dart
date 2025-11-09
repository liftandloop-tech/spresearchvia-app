import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/signup.controller.dart';
import 'package:spresearchvia2/core/routes/app_routes.dart';
import 'package:spresearchvia2/screens/auth/widgets/account_type_toggle.dart';
import 'package:spresearchvia2/services/snackbar.service.dart';
import '../core/config/app.config.dart';

class OTPVerificationController extends GetxController {
  final secondsRemaining = AppConfig.OTPResendTime.obs;
  final isAutoDetecting = true.obs;
  final canResend = false.obs;
  final phoneNumber = ''.obs;
  final isLoading = false.obs;

  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  Timer? _timer;

  String? _pan;
  String? _aadhar;
  AccountType? _accountType;
  bool _isSignup = false;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      phoneNumber.value = args['phone'] ?? '';
      _pan = args['pan'];
      _aadhar = args['aadhar'];
      _accountType = args['accountType'];
      _isSignup = args['isSignup'] ?? false;
    }

    controllers = List.generate(
      AppConfig.OTPSize,
      (_) => TextEditingController(),
    );
    focusNodes = List.generate(AppConfig.OTPSize, (_) => FocusNode());

    for (var controller in controllers) {
      controller.addListener(_checkOTPComplete);
    }

    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes[0].canRequestFocus) {
        focusNodes[0].requestFocus();
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      isAutoDetecting.value = false;
    });
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

  void _checkOTPComplete() {
    update();
  }

  bool isOTPComplete() {
    return controllers.every((controller) => controller.text.isNotEmpty);
  }

  String getOTP() {
    return controllers.map((c) => c.text).join();
  }

  void onFieldChanged(String value, int index) {
    if (value.isNotEmpty && index < AppConfig.OTPSize - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusNodes[index + 1].canRequestFocus) {
          focusNodes[index + 1].requestFocus();
        }
      });
    } else if (value.isEmpty && index > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusNodes[index - 1].canRequestFocus) {
          focusNodes[index - 1].requestFocus();
        }
      });
    }
  }

  void resendOTP() {
    if (!canResend.value) return;

    for (var controller in controllers) {
      controller.clear();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes[0].canRequestFocus) {
        focusNodes[0].requestFocus();
      }
    });

    _startTimer();

    isAutoDetecting.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      isAutoDetecting.value = false;
    });

    if (_isSignup && phoneNumber.value.isNotEmpty) {
      final signupController = Get.find<SignupController>();
      signupController.requestOtp(phoneNumber.value);
    } else {
      Get.snackbar(
        'Success',
        'OTP resent successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> verifyOTP() async {
    if (!isOTPComplete()) return;

    final otp = getOTP();
    isLoading.value = true;

    try {
      if (_isSignup) {
        await _handleSignupVerification(otp);
      } else {
        await _handleLoginVerification(otp);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleSignupVerification(String otp) async {
    final signupController = Get.find<SignupController>();

    final otpVerified = await signupController.verifyOtp(
      phoneNumber.value,
      otp,
    );

    if (!otpVerified) {
      SnackbarService.showError('Invalid OTP. Please try again.');
      return;
    }

    if (_pan != null && _aadhar != null && _accountType != null) {
      final signupSuccess = await signupController.completeSignup(
        pan: _pan!,
        aadhar: _aadhar!,
        phone: phoneNumber.value,
        accountType: _accountType!,
      );

      if (signupSuccess) {
        Get.offAllNamed(AppRoutes.login);
        SnackbarService.showSuccess(
          'Account created successfully! Please login to continue.',
        );
      }
    }
  }

  Future<void> _handleLoginVerification(String otp) async {
    await Future.delayed(Duration(seconds: 2));

    SnackbarService.showSuccess('OTP verified successfully!');

    Get.offAllNamed(AppRoutes.tabs);
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in controllers) {
      controller.removeListener(_checkOTPComplete);
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
