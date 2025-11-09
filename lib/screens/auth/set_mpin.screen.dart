import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/controllers/set_mpin.controller.dart';
import 'package:spresearchvia2/widgets/button.dart';

class SetMpinScreen extends StatelessWidget {
  const SetMpinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetMpinController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  height: 80,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              Text(
                'Set Your MPIN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlueDark,
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Create a 4-digit PIN for quick and secure login.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textGrey,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              GetBuilder<SetMpinController>(
                builder: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: 65,
                        height: 65,
                        child: TextField(
                          controller: controller.mpinControllers[index],
                          focusNode: controller.mpinFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlueDark,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:
                                    controller
                                        .mpinControllers[index]
                                        .text
                                        .isNotEmpty
                                    ? AppTheme.primaryBlueDark
                                    : AppTheme.borderGrey,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppTheme.primaryBlueDark,
                                width: 2.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) =>
                              controller.onMPINFieldChanged(value, index),
                          onTap: () {
                            if (controller
                                .mpinControllers[index]
                                .text
                                .isNotEmpty) {
                              controller.mpinControllers[index].selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: controller
                                          .mpinControllers[index]
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Use this PIN for future logins. Do not share it with anyone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textGrey,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              GetBuilder<SetMpinController>(
                builder: (_) {
                  final isMPINComplete = controller.isMPINComplete();
                  final isLoading = controller.isLoading.value;
                  return Button(
                    title: isLoading ? 'Setting MPIN...' : 'Continue',
                    buttonType: (isMPINComplete && !isLoading)
                        ? ButtonType.green
                        : ButtonType.greyBorder,
                    onTap: (isMPINComplete && !isLoading)
                        ? controller.setMPIN
                        : null,
                  );
                },
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "You'll use this MPIN for all future logins. OTP won't be required again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
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
