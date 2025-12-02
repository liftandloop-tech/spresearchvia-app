import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/kyc.controller.dart';
import '../../services/snackbar.service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_styles.dart';
import 'digio_connect_screen.dart';
import '../../widgets/button.dart';
import '../../widgets/kyc_step_indicator.dart';
import '../../widgets/data_protection_footer.dart';
import '../../widgets/title_field.dart';

class AadharVerificationScreen extends StatefulWidget {
  const AadharVerificationScreen({super.key});

  @override
  State<AadharVerificationScreen> createState() =>
      _AadharVerificationScreenState();
}

class _AadharVerificationScreenState extends State<AadharVerificationScreen> {
  final kycController = Get.find<KycController>();
  final TextEditingController _aadharController = TextEditingController();

  Future<void> _submitVerification() async {
    final aadharNumber = _aadharController.text.trim();

    if (aadharNumber.isEmpty) {
      SnackbarService.showWarning('Please enter Aadhar number');
      return;
    }

    if (aadharNumber.length != 12) {
      SnackbarService.showWarning('Aadhar number must be 12 digits');
      return;
    }

    Get.to(() => const DigioConnectScreen());
  }

  @override
  void dispose() {
    _aadharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
          onPressed: () => Get.back(),
        ),
        title: Text('KYC Verification', style: AppStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const KycStepIndicator(
              currentStep: 2,
              totalSteps: 3,
              title: 'KYC Verification',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLightBlue,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.credit_card_outlined,
                        color: AppTheme.primaryBlue,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Aadhar Verification', style: AppStyles.heading2),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide your Aadhar details for\nidentity verification',
                      textAlign: TextAlign.center,
                      style: AppStyles.bodySmall.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    TitleField(
                      title: 'Aadhar Number',
                      hint: 'Enter 12-digit Aadhar number',
                      controller: _aadharController,
                      icon: Icons.credit_card,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(
                    () => Button(
                      title: 'Submit for Verification',
                      onTap: kycController.isLoading.value
                          ? null
                          : _submitVerification,
                      buttonType: ButtonType.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const DataProtectionFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
