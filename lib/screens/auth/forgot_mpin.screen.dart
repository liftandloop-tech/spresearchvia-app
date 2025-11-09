import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/controllers/forgot_mpin.controller.dart';
import 'package:spresearchvia2/widgets/app_logo.dart';
import 'package:spresearchvia2/widgets/button.dart';

class ForgotMpinScreen extends StatelessWidget {
  const ForgotMpinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotMpinController());
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBlueDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: SizedBox(height: 80, child: AppLogo())),
              const SizedBox(height: 40),

              Text(
                'Forgot MPIN?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlueDark,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'No worries. Reset your MPIN easily with\nOTP verification.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textGrey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Enter your registered mobile number',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.primaryBlueDark,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              Obx(
                () => Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderGrey),
                        borderRadius: BorderRadius.circular(8),
                        color: controller.otpSent.value
                            ? AppTheme.borderGrey.withValues(alpha: 0.1)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '+91',
                            style: TextStyle(
                              fontSize: 16,
                              color: controller.otpSent.value
                                  ? AppTheme.textGrey
                                  : AppTheme.primaryBlueDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: controller.otpSent.value
                                ? AppTheme.textGrey
                                : AppTheme.primaryBlueDark,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        enabled: !controller.otpSent.value,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: controller.otpSent.value
                              ? AppTheme.textGrey
                              : AppTheme.primaryBlueDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter 10-digit number',
                          hintStyle: TextStyle(
                            color: AppTheme.textGrey.withValues(alpha: 0.5),
                            fontWeight: FontWeight.normal,
                          ),
                          counterText: '',
                          filled: true,
                          fillColor: controller.otpSent.value
                              ? AppTheme.borderGrey.withValues(alpha: 0.1)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppTheme.borderGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppTheme.borderGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.primaryBlue,
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppTheme.borderGrey),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Obx(
                () => !controller.otpSent.value
                    ? Button(
                        title: controller.isLoading.value
                            ? 'Sending...'
                            : 'Send OTP',
                        buttonType: ButtonType.blue,
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.sendOTP(
                                phoneController.text.trim(),
                              ),
                      )
                    : const SizedBox.shrink(),
              ),

              Obx(
                () => controller.otpSent.value
                    ? Column(
                        children: [
                          GetBuilder<ForgotMpinController>(
                            builder: (_) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: TextField(
                                      controller:
                                          controller.otpControllers[index],
                                      focusNode:
                                          controller.otpFocusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryBlueDark,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        contentPadding: EdgeInsets.zero,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                controller
                                                    .otpControllers[index]
                                                    .text
                                                    .isNotEmpty
                                                ? AppTheme.primaryBlueDark
                                                : AppTheme.borderGrey,
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppTheme.primaryBlueDark,
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) => controller
                                          .onOTPFieldChanged(value, index),
                                      onTap: () {
                                        if (controller
                                            .otpControllers[index]
                                            .text
                                            .isNotEmpty) {
                                          controller
                                                  .otpControllers[index]
                                                  .selection =
                                              TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: controller
                                                      .otpControllers[index]
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

                          Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textGrey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Obx(
                            () => Visibility(
                              visible: controller.canResend.value,
                              child: TextButton(
                                onPressed: controller.resendOTP,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
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
                          ),

                          Obx(
                            () => !controller.canResend.value
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Resend in ${controller.secondsRemaining.value.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textGrey,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 32),

                          GetBuilder<ForgotMpinController>(
                            builder: (_) {
                              final isOTPComplete = controller.isOTPComplete();
                              final isLoading = controller.isLoading.value;
                              return Button(
                                title: isLoading
                                    ? 'Verifying...'
                                    : 'Verify OTP',
                                buttonType: (isOTPComplete && !isLoading)
                                    ? ButtonType.green
                                    : ButtonType.greyBorder,
                                onTap: (isOTPComplete && !isLoading)
                                    ? controller.verifyOTP
                                    : null,
                              );
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "We'll send a 4-digit OTP to your registered mobile number.",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryBlueDark,
                          height: 1.4,
                        ),
                      ),
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
