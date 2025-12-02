import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/account_type_toggle.dart';
import '../../services/snackbar.service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/title_field.dart';
import '../../controllers/auth.controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<AuthController>();
    final accountTypeController = Get.put(
      AccountTypeController(),
      tag: 'signup',
    );
    final TextEditingController panController = TextEditingController();
    final TextEditingController aadharController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    Future<void> submit() async {
      final pan = panController.text.trim();
      final aadhar = aadharController.text.trim();
      final phone = phoneController.text.trim();

      if (pan.isEmpty) {
        SnackbarService.showError('Please enter PAN number');
        return;
      }

      if (aadhar.isEmpty) {
        SnackbarService.showError('Please enter Aadhar number');
        return;
      }

      if (phone.isEmpty) {
        // Mock PAN/Aadhar verification - return dummy phone
        final fetchedPhone = '9876543210';

        phoneController.text = fetchedPhone;

        SnackbarService.showSuccess(
          'Phone number verified. Please click submit again to continue.',
        );
        return;
      }

      Get.toNamed(
        AppRoutes.otpVerification,
        arguments: {
          'phone': phone,
          'pan': pan,
          'aadhar': aadhar,
          'accountType': accountTypeController.selectedType.value,
          'isSignup': true,
        },
      );
    }

    void back() {
      Get.back();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    width: double.maxFinite,
                    child: AppLogo(),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Create your account to start investing',
                    style: TextStyle(color: AppTheme.primaryBlue, fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Select Account Type',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  AccountTypeToggle(),
                  SizedBox(height: 30),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppTheme.borderGrey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TitleField(
                            title: 'PAN Card Number',
                            hint: 'eg: ABCDE1234F',
                            controller: panController,
                          ),
                          SizedBox(height: 20),
                          TitleField(
                            title: 'Aadhar Number',
                            hint: 'eg: 1234 5678 9012',
                            controller: aadharController,
                          ),
                          SizedBox(height: 20),
                          TitleField(
                            title: 'Phone Number',
                            hint: 'Will be fetched automatically',
                            controller: phoneController,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Obx(
                    () => Button(
                      buttonType: ButtonType.blue,
                      title: signupController.isLoading.value
                          ? 'Loading...'
                          : 'Submit',
                      onTap: signupController.isLoading.value ? null : submit,
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(
                    () => Button(
                      title: 'Back',
                      buttonType: ButtonType.greyBorder,
                      onTap: signupController.isLoading.value ? null : back,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 22.5,
                        color: AppTheme.primaryGreen,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your data is securely verified through official government APIs.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Obx(
              () => Visibility(
                visible: signupController.isLoading.value,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlueDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
