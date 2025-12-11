import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia/core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/button.dart';

class DigioConnectScreen extends StatelessWidget {
  const DigioConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onConnect() {
      Get.offAllNamed(AppRoutes.registrationScreen);
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
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xffE5E7EB)),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 6),
                      blurRadius: 20,
                      color: Color.fromARGB(25, 17, 65, 107),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/digio.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Connect Digio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        color: Color(0xff0B2B4A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect Digio for secure\nverification of your identity\ndocuments',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xff6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _point(
                      icon: Icons.check_circle,
                      color: const Color(0xff10B981),
                      text: 'Instant document verification',
                    ),
                    _point(
                      icon: Icons.check_circle,
                      color: const Color(0xff10B981),
                      text: 'Government-verified documents',
                    ),
                    _point(
                      icon: Icons.check_circle,
                      color: const Color(0xff10B981),
                      text: 'No physical document upload\nneeded',
                      multiline: true,
                    ),

                    const SizedBox(height: 16),

                    Button(
                      title: 'Connect Digio',
                      icon: Icons.link,
                      buttonType: ButtonType.green,
                      onTap: onConnect,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield, color: Color(0xff9CA3AF)),
                  SizedBox(width: 10),
                  Text(
                    'Your data is encrypted & safe',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xff9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Protected by 256-bit SSL encryption',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xff9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _point({
    required IconData icon,
    required Color color,
    required String text,
    bool multiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xff374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
