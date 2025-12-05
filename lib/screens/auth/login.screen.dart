import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/validators.dart';
import '../../controllers/auth.controller.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_styles.dart';
import 'package:flutter/services.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/title_field.dart';
import '../../services/snackbar.service.dart';
import '../kyc/sebi_compilance_check.dart';

part 'widgets/data_protection_footer.dart';

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
      final String input = phoneOrMailController.text.trim();
      final String mpin = mpinController.text.trim();

      if (input.isEmpty || mpin.isEmpty) {
        SnackbarService.showError(AppStrings.pleaseEnterCredentials);
        return;
      }

      final bool isEmail = Validators.isValidEmail(input);
      final bool isPhone = Validators.isValidPhone(input);

      if (!isEmail && !isPhone) {
        SnackbarService.showError(AppStrings.invalidPhoneAndEmail);
        return;
      }

      if (mpin.length != 4) {
        SnackbarService.showError('Enter valid MPIN');
        return;
      }

      final success = await authController.login(
        email: isEmail ? input : null,
        phone: isEmail ? null : input,
        mPin: mpin,
      );

      if (success) {
        Get.off(() => const SebiComplianceCheck());
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: responsive.padding(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.primaryBlue,
                        size: responsive.spacing(AppDimensions.iconLarge),
                      ),
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
                  style: AppStyles.welcomeText.copyWith(
                    fontSize: responsive.sp(24),
                  ),
                ),
                Text(
                  AppStrings.signInToAccess,
                  style: AppStyles.bodyLarge.copyWith(
                    fontSize: responsive.sp(16),
                  ),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  maxLength: 4,
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
