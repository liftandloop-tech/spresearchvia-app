import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spresearchvia2/controllers/kyc.controller.dart';
import 'package:spresearchvia2/core/utils/error_message_handler.dart';
import 'package:spresearchvia2/core/utils/custom_snackbar.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/screens/kyc/digio_connect_screen.dart';
import 'package:spresearchvia2/widgets/button.dart';
import 'package:spresearchvia2/widgets/kyc_step_indicator.dart';
import 'package:spresearchvia2/widgets/file_upload_section.dart';
import 'package:spresearchvia2/widgets/data_protection_footer.dart';
import 'package:spresearchvia2/widgets/title_field.dart';

class AadharVerificationScreen extends StatefulWidget {
  const AadharVerificationScreen({super.key});

  @override
  State<AadharVerificationScreen> createState() =>
      _AadharVerificationScreenState();
}

class _AadharVerificationScreenState extends State<AadharVerificationScreen> {
  final kycController = Get.find<KycController>();
  final TextEditingController _aadharController = TextEditingController();
  String? _selectedAadharFrontName;
  String? _selectedAadharBackName;
  File? _frontFile;
  File? _backFile;

  Future<void> _pickFrontFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _frontFile = File(result.files.single.path!);
          _selectedAadharFrontName = result.files.single.name;
        });
      }
    } catch (e) {
      ErrorMessageHandler.logError('Pick Aadhar Front File', e);
      CustomSnackbar.showErrorFromException(e, title: 'Failed to Pick File');
    }
  }

  Future<void> _pickBackFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _backFile = File(result.files.single.path!);
          _selectedAadharBackName = result.files.single.name;
        });
      }
    } catch (e) {
      ErrorMessageHandler.logError('Pick Aadhar Back File', e);
      CustomSnackbar.showErrorFromException(e, title: 'Failed to Pick File');
    }
  }

  Future<void> _submitVerification() async {
    final aadharNumber = _aadharController.text.trim();

    if (aadharNumber.isEmpty) {
      CustomSnackbar.showWarning('Please enter Aadhar number');
      return;
    }

    if (aadharNumber.length != 12) {
      CustomSnackbar.showWarning('Aadhar number must be 12 digits');
      return;
    }

    if (_frontFile == null || _backFile == null) {
      CustomSnackbar.showWarning('Please select both front and back images');
      return;
    }

    final success = await kycController.uploadAadharCard(
      frontFile: _frontFile!,
      backFile: _backFile!,
      aadharNumber: aadharNumber,
    );

    if (success) {
      Get.to(() => const DigioConnectScreen());
    }
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilePickerContainer(
                        title: 'Upload Aadhar Front Side',
                        subtitle: 'click to upload',
                        onTap: _pickFrontFile,
                        fileName: _selectedAadharFrontName,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilePickerContainer(
                        title: 'Upload Aadhar Back Side',
                        subtitle: 'click to upload',
                        onTap: _pickBackFile,
                        fileName: _selectedAadharBackName,
                      ),
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
