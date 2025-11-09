import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/config/app.config.dart';
import '../../controllers/otp_verification.controller.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.delete<OTPVerificationController>();
    final controller = Get.put(OTPVerificationController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(height: 80, child: AppLogo()),
              const SizedBox(height: 40),

              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.backgroundLightBlue,
                      ),
                      child: Icon(
                        Icons.phone_android,
                        size: 28,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Enter the ${AppConfig.OTPSize}-digit code sent to your\nregistered mobile number.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGrey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Obx(
                      () => Text(
                        "We've sent it to ${controller.phoneNumber.value}",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textGrey.withValues(alpha: 0.7),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    GetBuilder<OTPVerificationController>(
                      builder: (_) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(AppConfig.OTPSize, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              width: 45,
                              height: 50,
                              child: TextField(
                                controller: controller.controllers[index],
                                focusNode: controller.focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlueDark,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          controller
                                              .controllers[index]
                                              .text
                                              .isNotEmpty
                                          ? AppTheme.successGreen
                                          : AppTheme.borderGrey,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppTheme.successGreen,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) =>
                                    controller.onFieldChanged(value, index),
                                onTap: () {
                                  if (controller
                                      .controllers[index]
                                      .text
                                      .isNotEmpty) {
                                    controller.controllers[index].selection =
                                        TextSelection.fromPosition(
                                          TextPosition(
                                            offset: controller
                                                .controllers[index]
                                                .text
                                                .length,
                                          ),
                                        );
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Obx(
                      () => controller.isAutoDetecting.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.textGrey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Auto-detecting OTP...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textGrey,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 20),

                    Obx(
                      () => !controller.canResend.value
                          ? Text(
                              'Resend OTP in ${controller.secondsRemaining.value} s',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textGrey,
                              ),
                            )
                          : TextButton(
                              onPressed: controller.resendOTP,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 20),

                    Obx(() {
                      final isLoading = controller.isLoading.value;
                      return GetBuilder<OTPVerificationController>(
                        builder: (_) {
                          final isOTPComplete = controller.isOTPComplete();
                          return Button(
                            title: isLoading
                                ? 'Verifying...'
                                : 'Verify & Continue',
                            buttonType: (!isOTPComplete && !isLoading)
                                ? ButtonType.blue
                                : ButtonType.greyBorder,
                            showLoading: isLoading,
                            onTap: (isOTPComplete && !isLoading)
                                ? controller.verifyOTP
                                : null,
                          );
                        },
                      );
                    }),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Change Number',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: AppTheme.textGrey,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Your information is secure and encrypted',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
