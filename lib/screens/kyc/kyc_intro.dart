import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/auth/login.screen.dart';
import 'package:spresearchvia2/screens/kyc/pan_verification_screen.dart';
import 'package:spresearchvia2/widgets/app_logo.dart';
import 'package:spresearchvia2/widgets/button.dart';
import 'package:spresearchvia2/widgets/kyc_verification_card.dart';
import 'package:spresearchvia2/widgets/data_protection_footer.dart';

class KycIntroScreen extends StatelessWidget {
  const KycIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: AppLogo(),
                ),
                const SizedBox(height: 10),

                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xffEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/kyclogo.png'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Complete Your KYC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff11416B),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Verify with DigiLocker, PAN/Aadhar\n& SEBI compliance to access premium\nresearch and insights',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff6B7280),
                  ),
                ),
                const SizedBox(height: 15),
                const KycVerificationCard(
                  icon: Icons.phone_android_outlined,
                  title: 'Quick DigiLocker verification',
                ),
                const KycVerificationCard(
                  icon: Icons.description_outlined,
                  title: 'PAN & Aadhar authentication',
                ),
                const KycVerificationCard(
                  icon: Icons.verified_outlined,
                  title: 'SEBI compliance verification',
                ),
                const SizedBox(height: 20),
                Button(
                  title: 'Start KYC Verification',
                  iconRight: Icons.arrow_forward,
                  buttonType: ButtonType.green,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PanVerificationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text(
                      'Do it later',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xff6B7280),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const DataProtectionFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
