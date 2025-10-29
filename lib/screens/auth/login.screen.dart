import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/auth.controller.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
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
  final authController = Get.put(AuthController());
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> requestOTP() async {
      final phone = phoneController.text.trim();

      if (phone.isEmpty) {
        Get.snackbar('Error', 'Please enter your phone number');
        return;
      }

      await authController.sendOtp(phone);
      // isOtpSent is automatically updated in the controller
    }

    Future<void> verifyAndLogin() async {
      final phone = phoneController.text.trim();
      final otp = otpController.text.trim();

      if (phone.isEmpty || otp.isEmpty) {
        Get.snackbar('Error', 'Please enter phone number and OTP');
        return;
      }

      final success = await authController.verifyOtp(phone, otp);

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
              ),
              SizedBox(height: 20),
              Obx(
                () => Visibility(
                  visible: authController.isOtpSent.value,
                  child: TitleField(
                    title: 'OTP',
                    hint: 'Enter OTP',
                    controller: otpController,
                    icon: Icons.lock_outline,
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
