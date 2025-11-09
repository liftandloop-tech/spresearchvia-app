import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/routes/app_routes.dart';
import 'package:spresearchvia2/widgets/app_logo.dart';
import 'package:spresearchvia2/screens/splash/widgets/animated_loading_dots.dart';
import 'package:spresearchvia2/screens/splash/widgets/animated_loading_bar.dart';
import 'package:spresearchvia2/screens/splash/widgets/info_item.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Get.offAllNamed(AppRoutes.getStarted);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      AppLogo(),
                      const SizedBox(height: 16),
                      Container(
                        width: 64,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xff11416B),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Your Trusted Market\nResearch Partner',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff374151),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InfoItem(
                            icon: Icons.shield_outlined,
                            title: 'Secure',
                          ),
                          const SizedBox(width: 32),
                          InfoItem(
                            icon: Icons.flash_on_outlined,
                            title: 'Fast',
                          ),
                          const SizedBox(width: 32),
                          InfoItem(
                            icon: Icons.analytics_outlined,
                            title: 'Accurate',
                          ),
                        ],
                      ),
                      const Spacer(flex: 2),
                      AnimatedLoadingDots(controller: _controller),
                      const SizedBox(height: 16),
                      const Text(
                        'Loading your dashboard...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Version 2.1.0',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedLoadingBar(controller: _controller),
          ),
        ],
      ),
    );
  }
}
