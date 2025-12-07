import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/input_formatters.dart';
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
import '../../services/secure_storage.service.dart';

part 'widgets/data_protection_footer.dart';

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
    // Prefill phone/email from storage; leave MPIN empty
    Future.microtask(_prefillFromStorage);
  }

  Future<void> _prefillFromStorage() async {
    try {
      final userData = await _storage.getUserData();
      if (userData != null) {
        final String? phone = userData['phone'] as String?;
        final String? email = userData['email'] as String?;

        if (phone != null && phone.isNotEmpty) {
          // Stored format may include country code (e.g., 91XXXXXXXXXX)
          final normalized = phone.startsWith('91') && phone.length == 12
              ? phone.substring(2)
              : phone;
          phoneOrMailController.text = normalized;
        } else if (email != null && email.isNotEmpty) {
          phoneOrMailController.text = email;
        }

        // Always clear MPIN field for security
        mpinController.clear();
      }
    } catch (_) {
      // Silently ignore prefill errors
    }
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

    final success = await authController.login(
      email: isEmail ? processedInput : null,
      phone: isPhone ? processedInput : null,
      mPin: mpin,
    );

    if (success) {
      print('🟡 Login successful, checking subscription...');
      final hasSubscription = await authController.hasActiveSubscription();
      isLoading.value = false;

      if (hasSubscription) {
        print('✅ Has subscription, navigating to tabs');
        SnackbarService.showSuccess('Login successful!');
        Get.offAllNamed(AppRoutes.tabs);
      } else {
        print('⚠️ No subscription, navigating to registration');
        SnackbarService.showWarning(
          'No active subscription found, please register to continue',
        );
        Get.offAllNamed(AppRoutes.registrationScreen);
      }
    } else {
      isLoading.value = false;
      print('❌ Login failed');
    }
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final responsive = Responsive.of(context);

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
                  controller: controller.phoneOrMailController,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.text,
                  inputFormatters: [EmailOrPhoneInputFormatter()],
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing20)),
                TitleField(
                  title: AppStrings.mpin,
                  hint: AppStrings.enterMpin,
                  controller: controller.mpinController,
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
                Obx(
                  () => Button(
                    title: controller.isLoading.value
                        ? 'Logging in...'
                        : AppStrings.login,
                    buttonType: ButtonType.blue,
                    onTap: controller.isLoading.value
                        ? null
                        : controller.handleLogin,
                    showLoading: controller.isLoading.value,
                  ),
                ),
                SizedBox(height: responsive.spacing(AppDimensions.spacing10)),
                Button(
                  title: AppStrings.back,
                  buttonType: ButtonType.greyBorder,
                  onTap: () => Get.back(),
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
