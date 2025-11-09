import 'package:flutter/material.dart';

import '../../../controllers/plan_selection.controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../screens/subscription/widgets/plan.card.dart';

/// Plan selector widget with multiple plan options
class PlanSelector extends StatelessWidget {
  final PlanSelectionController controller;
  final BoxDecoration? decoration;

  const PlanSelector({super.key, required this.controller, this.decoration});

  @override
  Widget build(BuildContext context) {
    final containerDecoration =
        decoration ??
        BoxDecoration(
          border: Border.all(color: AppTheme.borderGrey),
          borderRadius: BorderRadius.circular(12),
        );

    return Container(
      decoration: containerDecoration,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          PlanCard(
            planName: controller.planDetails[PlanType.annual]!['name'],
            amount: controller.planDetails[PlanType.annual]!['amount'],
            validity: controller.planDetails[PlanType.annual]!['validity'],
            selected: controller.isSelected(PlanType.annual),
            onTap: () => controller.selectPlan(PlanType.annual),
          ),
          const SizedBox(height: 10),
          PlanCard(
            planName: controller.planDetails[PlanType.oneTime]!['name'],
            amount: controller.planDetails[PlanType.oneTime]!['amount'],
            validity: controller.planDetails[PlanType.oneTime]!['validity'],
            selected: controller.isSelected(PlanType.oneTime),
            onTap: () => controller.selectPlan(PlanType.oneTime),
          ),
        ],
      ),
    );
  }
}
