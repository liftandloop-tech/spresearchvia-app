import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';

enum AccountType { trader, investor, both }

class AccountTypeController extends GetxController {
  var selectedType = AccountType.trader.obs;

  String get choosenType {
    switch (selectedType.value) {
      case AccountType.trader:
        return 'Trader';
      case AccountType.investor:
        return 'Investor';
      case AccountType.both:
        return 'Both';
    }
  }

  void selectAccountType(AccountType type) {
    if (selectedType.value == type) return;
    selectedType.value = type;
  }
}

class AccountTypeToggle extends StatelessWidget {
  const AccountTypeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountTypeController>(tag: 'signup');

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppTheme.infoBackground,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          final buttonWidth = (constraints.biggest.width - 16) / 3;

          return Stack(
            children: [
              Obx(() {
                double leftPosition;
                switch (controller.selectedType.value) {
                  case AccountType.trader:
                    leftPosition = 0;
                    break;
                  case AccountType.investor:
                    leftPosition = buttonWidth + 8;
                    break;
                  case AccountType.both:
                    leftPosition = (buttonWidth + 8) * 2;
                    break;
                }

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubicEmphasized,
                  left: leftPosition,
                  top: 0,
                  bottom: 0,
                  width: buttonWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlueDark,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlueDark.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              Row(
                children: [
                  Expanded(
                    child: _ToggleButton(
                      text: 'Trader',
                      controller: controller,
                      type: AccountType.trader,
                    ),
                  ),
                  Expanded(
                    child: _ToggleButton(
                      text: 'Investor',
                      controller: controller,
                      type: AccountType.investor,
                    ),
                  ),
                  Expanded(
                    child: _ToggleButton(
                      text: 'Both',
                      controller: controller,
                      type: AccountType.both,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final AccountTypeController controller;
  final AccountType type;

  const _ToggleButton({
    required this.text,
    required this.controller,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return GestureDetector(
        onTap: () => controller.selectAccountType(type),
        child: Container(
          width: double.maxFinite,
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF9e9e9e),
              letterSpacing: isSelected ? 0.5 : 0,
            ),
            child: Text(text),
          ),
        ),
      );
    });
  }
}
