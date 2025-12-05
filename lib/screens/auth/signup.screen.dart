import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/account_type_toggle.dart';
import '../../services/snackbar.service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/title_field.dart';
import '../../controllers/auth.controller.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/input_formatters.dart';
import '../../core/constants/app_dimensions.dart';
import 'otp_verification.screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<AuthController>();
    Get.put(AccountTypeController(), tag: 'signup');
    final TextEditingController panController = TextEditingController();
    // DOB split controllers
    final TextEditingController dayController = TextEditingController();
    final TextEditingController monthController = TextEditingController();
    final TextEditingController yearController = TextEditingController();
    final FocusNode dayFocus = FocusNode();
    final FocusNode monthFocus = FocusNode();
    final FocusNode yearFocus = FocusNode();
    final TextEditingController aadharController = TextEditingController();

    Future<void> submit() async {
      final pan = panController.text.trim();
      final dd = dayController.text.trim();
      final mm = monthController.text.trim();
      final yyyy = yearController.text.trim();
      if (dd.isEmpty || mm.isEmpty || yyyy.isEmpty) {
        SnackbarService.showError('Date of Birth is required');
        return;
      }
      final dob = '${dd.padLeft(2, '0')}-${mm.padLeft(2, '0')}-$yyyy';
      final aadhar = aadharController.text.trim();

      final panError = Validators.validatePAN(pan);
      if (panError != null) {
        SnackbarService.showError(panError);
        return;
      }

      final dobError = Validators.validateDOB(dob);
      if (dobError != null) {
        SnackbarService.showError(dobError);
        return;
      }

      final aadharError = Validators.validateAadhar(aadhar);
      if (aadharError != null) {
        SnackbarService.showError(aadharError);
        return;
      }

      final success = await signupController.createUser(
        pan: Validators.formatPAN(pan),
        dob: Validators.normalizeDob(dob),
        aadhaarNumber: Validators.cleanAadhar(aadhar),
      );

      if (success) {
        Get.off(() => const OtpVerificationScreen());
      }
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
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              PANInputFormatter(),
                            ],
                          ),
                          SizedBox(height: 20),
                          _DobTripleField(
                            dayController: dayController,
                            monthController: monthController,
                            yearController: yearController,
                            dayFocus: dayFocus,
                            monthFocus: monthFocus,
                            yearFocus: yearFocus,
                          ),
                          SizedBox(height: 20),
                          TitleField(
                            title: 'Aadhar Number',
                            hint: 'eg: 1234 5678 9012',
                            controller: aadharController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              AadharInputFormatter(),
                            ],
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

class _DobTripleField extends StatelessWidget {
  const _DobTripleField({
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.dayFocus,
    required this.monthFocus,
    required this.yearFocus,
  });

  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final FocusNode dayFocus;
  final FocusNode monthFocus;
  final FocusNode yearFocus;

  @override
  Widget build(BuildContext context) {
    final labelStyle = const TextStyle(
      fontFamily: 'Poppins',
      color: AppTheme.primaryBlue,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    final hintStyle = const TextStyle(
      fontSize: 14,
      color: AppTheme.textGreyLight,
      fontFamily: 'Poppins',
    );

    InputDecoration _decoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: hintStyle,
      border: InputBorder.none,
      counterText: '',
    );

    Widget _box({
      required TextEditingController controller,
      required FocusNode focusNode,
      required String hint,
      required int maxLength,
      void Function(String)? onChanged,
    }) {
      return Container(
        height: AppDimensions.containerSmall,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF9FAFB),
          border: Border.all(
            width: AppDimensions.borderThin,
            color: AppTheme.borderGrey,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: maxLength,
            onChanged: onChanged,
            decoration: _decoration(hint),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date of Birth', style: labelStyle),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _box(
                controller: dayController,
                focusNode: dayFocus,
                hint: 'DD',
                maxLength: 2,
                onChanged: (v) {
                  if (v.length == 2) {
                    FocusScope.of(context).requestFocus(monthFocus);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _box(
                controller: monthController,
                focusNode: monthFocus,
                hint: 'MM',
                maxLength: 2,
                onChanged: (v) {
                  if (v.length == 2) {
                    FocusScope.of(context).requestFocus(yearFocus);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: _box(
                controller: yearController,
                focusNode: yearFocus,
                hint: 'YYYY',
                maxLength: 4,
                onChanged: (v) {
                  if (v.length == 4) {
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
