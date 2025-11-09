import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/auth.controller.dart';
import 'package:spresearchvia2/core/routes/app_routes.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/core/utils/input_formatters.dart';
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
  final phoneOrMailController = TextEditingController();
  final mpinController = TextEditingController();

  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    authController.resetOtpState();
  }

  @override
  void dispose() {
    phoneOrMailController.dispose();
    mpinController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void toGetStarted() {
      Get.back();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: AppLogo(),
                ),
                SizedBox(height: 20),
                Text("Welcome Back", style: AppStyles.welcomeText),
                Text(
                  "Sign in to access your portfolio",
                  style: AppStyles.bodyLarge,
                ),
                SizedBox(height: 40),
                TitleField(
                  title: 'Email or Phone',
                  hint: 'Enter your email or phone',
                  controller: phoneOrMailController,
                  icon: Icons.phone_outlined,

                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'MPin',
                  hint: 'Enter your MPin',
                  controller: mpinController,
                  icon: Icons.lock_outline,
                  inputFormatters: [OTPInputFormatter()],
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.forgotMpin);
                    },
                    child: Text(
                      'Forgot MPIN?',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                Button(
                  title: 'Login',
                  buttonType: ButtonType.blue,
                  onTap: toGetStarted,
                ),
                SizedBox(height: 10),
                Button(
                  title: 'Back',
                  buttonType: ButtonType.greyBorder,
                  onTap: toGetStarted,
                ),
                SizedBox(height: 20),
                DataProtection(),
              ],
            ),
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
