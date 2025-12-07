import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SPResearchvia/controllers/segment_plan.controller.dart';
import 'package:SPResearchvia/core/theme/app_theme.dart';
import 'package:SPResearchvia/screens/subscription/widgets/segment.dropdown.dart';
import 'package:SPResearchvia/widgets/button.dart';

class SelectSegmentScreen extends StatelessWidget {
  SelectSegmentScreen({super.key});

  final segmentPlanController = Get.find<SegmentPlanController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back, color: AppTheme.textBlack),
                ),
                Text(
                  'Select Your Research Segment',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Choose the segment and plan type that suits your trading preference.',
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 12, color: AppTheme.textBlack),
                ),
                SizedBox(height: 15),
                Divider(height: 1, color: AppTheme.borderGrey),
                SizedBox(height: 15),
                Text(
                  'Select Segment',
                  style: TextStyle(fontSize: 14, color: AppTheme.primaryBlue),
                ),
                SizedBox(height: 15),
                SegmentDropdownMenu(),
                SizedBox(height: 15),

                Obx(() {
                  if (segmentPlanController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Loading plans...',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (segmentPlanController.error.value != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load plans',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              segmentPlanController.error.value ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textGrey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => segmentPlanController.retry(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final plans = segmentPlanController.availablePlans;
                  if (plans.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'No plans available',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (final plan in plans) ...[
                        SegmentPlanCard(
                          id: plan.id,
                          name: plan.name,
                          description: plan.description,
                          amount: plan.amount,
                          perDay: plan.perDay,
                          benefits: plan.benefits,
                          badge: plan.badge,
                          isPopular: plan.isPopular,
                          isSelected: segmentPlanController.isPlanSelected(
                            plan.id,
                          ),
                          onTap: () =>
                              segmentPlanController.selectPlan(plan.id),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                }),

                SizedBox(height: 20),
                Divider(color: AppTheme.infoBorder),
                SizedBox(height: 15),
                Obx(() {
                  final hasSelection =
                      segmentPlanController.selectedPlanId.value != null;
                  final selectedPlan = segmentPlanController.selectedPlan;

                  return Button(
                    title: 'Continue to Payment',
                    buttonType: ButtonType.green,
                    onTap: hasSelection
                        ? () {
                            Get.toNamed(
                              '/confirm-payment',
                              arguments: {'plan': selectedPlan},
                            );
                          }
                        : null,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SegmentPlanCard extends StatelessWidget {
  const SegmentPlanCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.perDay,
    required this.benefits,
    required this.isSelected,
    this.badge,
    this.isPopular = false,
    this.onTap,
  });

  final String id;
  final String name, description, amount, perDay;
  final List<String> benefits;
  final bool isSelected;
  final String? badge;
  final bool isPopular;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isHNI = name == 'HNI Custom Plan';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? AppTheme.primaryGreen.withValues(alpha: 0.05)
              : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPopular
                        ? AppTheme.primaryGreen
                        : AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      if (isHNI) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppTheme.textGrey,
                        ),
                      ],
                    ],
                  ),
                ),
                Radio<bool>(
                  value: true,
                  groupValue: isSelected,
                  onChanged: onTap != null ? (_) => onTap!() : null,
                  activeColor: AppTheme.primaryGreen,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: AppTheme.textBlack),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amount,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      if (isHNI)
                        const Text(
                          '(Excl. GST)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textGrey,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      perDay.split('\n')[0],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    if (perDay.contains('\n'))
                      Text(
                        perDay.split('\n')[1],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            for (String benefit in benefits)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.primaryGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
