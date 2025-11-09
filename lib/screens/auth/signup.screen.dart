import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/routes/app_routes.dart';
import 'package:spresearchvia2/screens/auth/widgets/account_type_toggle.dart';
import 'package:spresearchvia2/services/snackbar.service.dart';
import 'package:spresearchvia2/widgets/app_logo.dart';
import 'package:spresearchvia2/widgets/button.dart';
import 'package:spresearchvia2/widgets/title_field.dart';

import '../../controllers/signup.controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signupController = Get.put(SignupController());
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  AccountTypeController get accountTypeController =>
      Get.find<AccountTypeController>(tag: 'signup');

  @override
  void dispose() {
    _panController.dispose();
    _aadharController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final pan = _panController.text.trim();
    final aadhar = _aadharController.text.trim();
    final phone = _phoneController.text.trim();

    if (pan.isEmpty) {
      SnackbarService.showError('Please enter PAN number');
      return;
    }

    if (aadhar.isEmpty) {
      SnackbarService.showError('Please enter Aadhar number');
      return;
    }

    if (phone.isEmpty) {
      final fetchedPhone = await signupController.verifyPanAadhar(
        pan: pan,
        aadhar: aadhar,
        accountType: accountTypeController.selectedType.value,
      );

      if (fetchedPhone == null) {
        return;
      }

      setState(() {
        _phoneController.text = fetchedPhone;
      });

      SnackbarService.showSuccess(
        'Phone number verified. Please click submit again to continue.',
      );
      return;
    }

    if (phone.isEmpty) {
      SnackbarService.showError('Please enter phone number');
      return;
    }

    final otpSent = await signupController.requestOtp(phone);

    if (!otpSent) {
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

  @override
  Widget build(BuildContext context) {
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
                            controller: _panController,
                          ),
                          SizedBox(height: 20),
                          TitleField(
                            title: 'Aadhar Number',
                            hint: 'eg: 1234 5678 9012',
                            controller: _aadharController,
                          ),
                          SizedBox(height: 20),
                          TitleField(
                            title: 'Phone Number',
                            hint: 'Will be fetched automatically',
                            controller: _phoneController,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lock, size: 20, color: AppTheme.primaryGreen),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your data is securely verified through official government APIs.',
                          style: TextStyle(
                            fontSize: 14,
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
