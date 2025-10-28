import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/kyc/aadhar_verification_screen.dart';
import 'package:spresearchvia2/widgets/button.dart';
import 'package:spresearchvia2/widgets/kyc_step_indicator.dart';
import 'package:spresearchvia2/widgets/file_upload_section.dart';
import 'package:spresearchvia2/widgets/data_protection_footer.dart';
import 'package:spresearchvia2/widgets/title_field.dart';

class PanVerificationScreen extends StatefulWidget {
  const PanVerificationScreen({super.key});

  @override
  State<PanVerificationScreen> createState() => _PanVerificationScreenState();
}

class _PanVerificationScreenState extends State<PanVerificationScreen> {
  final TextEditingController _panController = TextEditingController();
  String? _selectedFileName;

  void _pickFile() {
    setState(() {
      _selectedFileName = 'PAN_Card.pdf';
    });
  }

  void _submitVerification() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AadharVerificationScreen()),
    );
  }

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff11416B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff11416B),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const KycStepIndicator(
              currentStep: 1,
              totalSteps: 3,
              title: 'KYC Verification',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xffEFF6FF),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.credit_card_outlined,
                        color: Color(0xff11416B),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'PAN Verification',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff11416B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please provide your PAN details for\nidentity verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xff6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TitleField(
                      title: 'PAN Number',
                      hint: 'eg: ABCDE1234F',
                      controller: _panController,
                      icon: Icons.credit_card,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilePickerContainer(
                        title: 'Upload PAN Front Side',
                        subtitle: 'click to upload',
                        onTap: _pickFile,
                        fileName: _selectedFileName,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Button(
                    title: 'Submit for Verification',
                    onTap: _submitVerification,
                    buttonType: ButtonType.green,
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
