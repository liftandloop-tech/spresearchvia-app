import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/auth.controller.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/core/utils/validators.dart';
import 'package:spresearchvia2/core/utils/input_formatters.dart';
import 'package:spresearchvia2/screens/auth/signup.screen.dart';
import 'package:spresearchvia2/screens/tabs.screen.dart';
import 'package:spresearchvia2/widgets/app_logo.dart';
import 'package:spresearchvia2/widgets/button.dart';
import 'package:spresearchvia2/widgets/title_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.find<AuthController>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    authController.resetOtpState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 90;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String getPhoneWithCountryCode(String phone) {
      final cleaned = Validators.cleanPhone(phone);
      if (cleaned.startsWith('+91')) return cleaned;
      if (cleaned.length == 10) return '+91$cleaned';
      return cleaned;
    }

    Future<void> requestOTP() async {
      final phone = phoneController.text.trim();
      final phoneValidation = Validators.validatePhone(phone);
      if (phoneValidation != null) {
        Get.snackbar('Error', phoneValidation);
        return;
      }
      final phoneWithCode = getPhoneWithCountryCode(phone);
      final success = await authController.sendOtp(phoneWithCode);
      if (success) {
        _startResendTimer();
      }
    }

    Future<void> verifyAndLogin() async {
      final phone = phoneController.text.trim();
      final otp = otpController.text.trim();
      final phoneValidation = Validators.validatePhone(phone);
      if (phoneValidation != null) {
        Get.snackbar('Error', phoneValidation);
        return;
      }
      final otpValidation = Validators.validateOTP(otp);
      if (otpValidation != null) {
        Get.snackbar('Error', otpValidation);
        return;
      }
      final phoneWithCode = getPhoneWithCountryCode(phone);
      final success = await authController.verifyOtp(phoneWithCode, otp);
      if (success) {
        Get.offAll(() => const TabsScreen());
      }
    }

    void toSignUpScreen() {
      Get.off(() => SignupScreen());
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              SizedBox(height: 100, width: double.maxFinite, child: AppLogo()),
              SizedBox(height: 20),
              Text("Welcome Back", style: AppStyles.welcomeText),
              Text(
                "Sign in to access your portfolio",
                style: AppStyles.bodyLarge,
              ),
              SizedBox(height: 40),
              TitleField(
                title: 'Phone Number',
                hint: 'Enter your phone number',
                controller: phoneController,
                icon: Icons.phone_outlined,

                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
              SizedBox(height: 20),
              Obx(
                () => Visibility(
                  visible: authController.isOtpSent.value,
                  child: Column(
                    children: [
                      TitleField(
                        title: 'OTP',
                        hint: 'Enter OTP',
                        controller: otpController,
                        icon: Icons.lock_outline,
                        inputFormatters: [OTPInputFormatter()],
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_resendCountdown > 0)
                            Text(
                              "Resend in ${_resendCountdown}s",
                              style: AppStyles.bodySmall.copyWith(
                                color: AppTheme.textGrey,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: authController.isLoading.value
                                  ? null
                                  : requestOTP,
                              child: Text("Resend OTP", style: AppStyles.link),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Obx(
                () => Button(
                  title: authController.isOtpSent.value
                      ? 'Verify & Sign In'
                      : 'Request OTP',
                  onTap: authController.isLoading.value
                      ? null
                      : (authController.isOtpSent.value
                            ? verifyAndLogin
                            : requestOTP),
                  buttonType: ButtonType.green,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: toSignUpScreen,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppStyles.bodyMedium,
                      ),
                      Text("Sign Up", style: AppStyles.link),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              DataProtection(),
            ],
          ),
        ),
      ),
    );
  }
}

class DataProtection extends StatelessWidget {
  const DataProtection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, color: AppTheme.textGrey),
          Text(
            " Your data is protected with bank-level security",
            style: AppStyles.caption,
          ),
        ],
      ),
    );
  }
}
