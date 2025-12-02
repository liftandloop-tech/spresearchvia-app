import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth.controller.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_styles.dart';
import '../../core/utils/input_formatters.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/title_field.dart';
import '../../services/snackbar.service.dart';

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
    final responsive = Responsive.of(context);

    Future<void> handleLogin() async {
      final input = phoneOrMailController.text.trim();
      final mpin = mpinController.text.trim();
      if (input.isEmpty || mpin.isEmpty) {
        SnackbarService.showError(AppStrings.pleaseEnterCredentials);
        return;
      }

      final success = await authController.verifyOtp(input);
      if (success) {
        Get.offAllNamed(AppRoutes.tabs);
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: responsive.padding(horizontal: AppDimensions.paddingMedium, vertical: AppDimensions.paddingSmall),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryBlue, size: responsive.spacing(AppDimensions.iconLarge)),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing20)),
                SizedBox(
                  height: responsive.spacing(AppDimensions.logoHeight),
                  width: double.maxFinite,
                  child: AppLogo(),
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing20)),
                Text(
                  AppStrings.welcomeBack,
                  style: AppStyles.welcomeText.copyWith(fontSize: responsive.sp(24)),
                ),
                Text(
                  AppStrings.signInToAccess,
                  style: AppStyles.bodyLarge.copyWith(fontSize: responsive.sp(16)),
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing40)),
                TitleField(
                  title: AppStrings.emailOrPhone,
                  hint: AppStrings.enterEmailOrPhone,
                  controller: phoneOrMailController,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing20)),
                TitleField(
                  title: AppStrings.mpin,
                  hint: AppStrings.enterMpin,
                  controller: mpinController,
                  icon: Icons.lock_outline,
                  inputFormatters: [OTPInputFormatter()],
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing10)),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.forgotMpin);
                    },
                    child: Text(
                      AppStrings.forgotMpin,
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: responsive.sp(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing40)),
                Button(
                  title: AppStrings.login,
                  buttonType: ButtonType.blue,
                  onTap: handleLogin,
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing10)),
                Button(
                  title: AppStrings.back,
                  buttonType: ButtonType.greyBorder,
                  onTap: () => Get.offAllNamed(AppRoutes.getStarted),
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing20)),
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
    final responsive = Responsive.of(context);

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            color: AppTheme.textGrey,
            size: responsive.spacing(AppDimensions.iconMedium),
          ),
          Flexible(
            child: Text(
              " ${AppStrings.dataProtection}",
              style: AppStyles.caption.copyWith(fontSize: responsive.sp(12)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
