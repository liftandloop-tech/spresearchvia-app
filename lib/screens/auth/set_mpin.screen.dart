import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth.controller.dart';
import '../../services/snackbar.service.dart';
import '../../services/secure_storage.service.dart';
import '../../widgets/app_logo.dart';
import '../kyc/sebi_compilance_check.dart';
import 'widgets/pin_input_boxes.dart';

class SetMpinScreen extends StatelessWidget {
  const SetMpinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final storage = SecureStorageService();

    Future<void> setMpin(String mpin) async {
      final userData = await storage.getUserData();
      final phone = userData?['phone'] ?? userData?['userObject']?['APP_MOB_NO'];
      if (phone == null) {
        SnackbarService.showError('Phone number not found');
        return;
      }
      final success = await authController.setMpin(phone.toString(), mpin);
      if (success) Get.off(() => const SebiComplianceCheck());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                AppLogo(),
                SizedBox(height: 60),
                Text('Set Your MPIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff0B3A70))),
                SizedBox(height: 12),
                Text('Create a 4-digit PIN for quick and secure login.', style: TextStyle(fontSize: 14, color: Color(0xff6B7280))),
                SizedBox(height: 40),
                PinInputBoxes(length: 4, onCompleted: setMpin, obscureText: true),
                SizedBox(height: 16),
                Text('Use this PIN for future logins. Do not share it with\nanyone.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xff9CA3AF))),
                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Continue', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 12),
                Text('You\'ll use this MPIN for all future logins. OTP won\'t be\nrequired again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xff9CA3AF))),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
