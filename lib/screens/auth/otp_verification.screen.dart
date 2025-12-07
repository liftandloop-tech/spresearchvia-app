import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth.controller.dart';
import '../../widgets/app_logo.dart';
import 'set_mpin.screen.dart';
import 'widgets/pin_input_boxes.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    Future<void> verifyOtp(String otp) async {
      final success = await authController.verifyOtp(otp);
      if (success) Get.off(() => const SetMpinScreen());
    }

    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              AppLogo(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xffEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.phone_android,
                    size: 40,
                    color: Color(0xff0B3A70),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0B3A70),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Enter the 6-digit code sent to your\nregistered mobile number.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xff6B7280)),
                ),
                SizedBox(height: 8),
                Text(
                  'We\'ve sent it to +91-XXXXXX1234',
                  style: TextStyle(fontSize: 12, color: Color(0xff9CA3AF)),
                ),
                SizedBox(height: 32),
                PinInputBoxes(length: 4, onCompleted: verifyOtp),
                SizedBox(height: 16),
                Text(
                  'Auto-detecting OTP...',
                  style: TextStyle(fontSize: 12, color: Color(0xff9CA3AF)),
                ),
                SizedBox(height: 40),
                Text(
                  'Resend OTP in 26 s',
                  style: TextStyle(fontSize: 14, color: Color(0xff6B7280)),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffD1D5DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Verify & Continue',
                      style: TextStyle(fontSize: 16, color: Color(0xff6B7280)),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: Color(0xff9CA3AF),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Your information is secure and encrypted',
                      style: TextStyle(fontSize: 12, color: Color(0xff9CA3AF)),
                    ),
                  ],
                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
