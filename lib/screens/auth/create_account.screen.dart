import 'package:spresearchvia/core/theme/app_theme.dart';
import 'package:spresearchvia/widgets/app_logo.dart';
import 'package:spresearchvia/widgets/button.dart';
import 'package:spresearchvia/widgets/title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../controllers/auth.controller.dart';
import '../../core/routes/app_routes.dart';
import '../../services/snackbar.service.dart';
import '../../core/utils/validators.dart';

class CreateAccountController extends GetxController {
  final authController = Get.find<AuthController>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> handleContinue(BuildContext context) async {
    final name = fullNameController.text.trim();
    final phone = phoneController.text.trim();

    final nameError = Validators.validateName(name, fieldName: 'Full name');
    if (nameError != null) {
      SnackbarService.showError(nameError, context: context);
      return;
    }

    final phoneError = Validators.validatePhone(phone);
    if (phoneError != null) {
      SnackbarService.showError(phoneError, context: context);
      return;
    }

    isLoading.value = true;

    try {
      final success = await authController.createUser(
        fullName: name,
        phone: '91$phone',
      );

      if (success) {
        Get.toNamed(
          AppRoutes.otpVerification,
          arguments: {'phone': '91$phone', 'fullName': name, 'flow': 'signup'},
        );
      }
    } catch (e) {
      SnackbarService.showError(
        'An error occurred. Please try again.',
        context: context,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.maxFinite,
                    height: 60,
                    child: AppLogo(),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Create Your Account',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ).copyWith(color: AppTheme.primaryBlueDark),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter your details to get started.',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ).copyWith(color: AppTheme.textGrey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderGrey),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TitleField(
                            title: 'Full Name',
                            hint: 'Enter your full name',
                            controller: controller.fullNameController,
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 20),
                          TitleField(
                            title: 'Mobile Number',
                            hint: '1234567890',
                            controller: controller.phoneController,
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => Button(
                              title: controller.isLoading.value
                                  ? 'Sending OTP...'
                                  : 'Continue',
                              buttonType: ButtonType.green,
                              onTap: controller.isLoading.value
                                  ? null
                                  : () => controller.handleContinue(context),
                              showLoading: controller.isLoading.value,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Button(
                            title: AppStrings.back,
                            buttonType: ButtonType.greyBorder,
                            onTap: () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy.',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ).copyWith(color: AppTheme.textGrey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
