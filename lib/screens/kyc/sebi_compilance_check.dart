import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/auth/login.screen.dart';

import '../../widgets/button.dart';

class SebiComplianceCheck extends StatelessWidget {
  const SebiComplianceCheck({super.key});

  @override
  Widget build(BuildContext context) {
    void continueToLogin() {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff111827),
            size: 18,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'SEBI Verification',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xff111827),
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 30),

              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF9EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Color(0xff10B981),
                      size: 35,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'KYC Completed Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Color(0xff11416B),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Your KYC has been submitted successfully.\nPlease login to access your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xff6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffECFDF3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xff10B981),
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'SEBI Compliant Account',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xff065F46),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const FeatureCard(
                icon: Icons.show_chart,
                title: 'Real-time Trading',
                subtitle:
                    'Access live market data and execute trades\ninstantly',
              ),
              const SizedBox(height: 12),
              const FeatureCard(
                icon: Icons.lock_outline,
                title: 'Secure Portfolio',
                subtitle: 'Bank-grade security for your investments',
              ),
              const SizedBox(height: 12),
              const FeatureCard(
                icon: Icons.school_outlined,
                title: 'Learning Resources',
                subtitle: 'Educational content to improve your trading skills',
              ),

              const SizedBox(height: 24),

              Button(
                title: 'Continue to Login',
                onTap: continueToLogin,
                buttonType: ButtonType.green,
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Please login with your credentials to complete the verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xff6B7280),
                    height: 1.4,
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

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 248, 255),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xffEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xff0B3A70)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff0B3A70),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xff6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
