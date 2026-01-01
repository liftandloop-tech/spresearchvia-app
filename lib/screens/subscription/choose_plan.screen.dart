import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/active_plan_card.dart';
import '../../core/models/plan.dart';
import '../../controllers/segment_plan.controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/button.dart';
import 'widgets/feature_item.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  final segmentController = Get.put(SegmentPlanController());

  @override
  void initState() {
    super.initState();
    segmentController.fetchActiveSegment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Choose Your Segment',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlueDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Unlock Premium Features',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlueDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              const Text(
                'Get advanced analytics, unlimited transactions,\nand priority support',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppTheme.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Obx(() {
                final segment = segmentController.activeSegment.value;
                final isLoading = segmentController.isLoadingSegment.value;
                final hasActiveSegment =
                    segmentController.hasActiveSegment.value;

                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlue,
                    ),
                  );
                }

                if (!hasActiveSegment || segment == null) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'No active plan found.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                    ),
                  );
                }

                final segmentData =
                    segment['segmentId'] as Map<String, dynamic>?;
                final segmentName = segmentData?['segmentName'] ?? 'Segment';
                final amountStr = segmentData?['amount']?.toString() ?? '0';
                final amount = double.tryParse(amountStr) ?? 0;

                // Parse validity handling "365 days" format
                var validityStr = segmentData?['validity']?.toString() ?? '0';
                final validity =
                    int.tryParse(
                      validityStr.replaceAll(RegExp(r'[^0-9]'), ''),
                    ) ??
                    0;

                // Get daysCharge directly
                final daysChargeStr =
                    segmentData?['daysCharge']?.toString() ?? '0';
                final daysCharge = int.tryParse(daysChargeStr) ?? 0;

                final endDate = segment['expiryDate'] != null
                    ? DateTime.parse(segment['expiryDate'])
                    : DateTime.now().add(Duration(days: validity));

                final startDate = segment['startDate'] != null
                    ? DateTime.parse(segment['startDate'])
                    : (segment['purchaseDate'] != null
                          ? DateTime.parse(segment['purchaseDate'])
                          : endDate.subtract(Duration(days: validity)));

                final now = DateTime.now();
                final totalDuration = endDate.difference(startDate).inDays;
                final elapsed = now.difference(startDate).inDays;
                var completion = 0;
                if (totalDuration > 0) {
                  completion = ((elapsed / totalDuration) * 100)
                      .clamp(0, 100)
                      .toInt();
                }

                final perDayCost = daysCharge > 0
                    ? daysCharge
                    : (validity > 0 ? (amount / validity).round() : 0);

                return ActivePlanCard(
                  plan: Plan(
                    id: segment['id'] ?? '',
                    name: segmentName,
                    amount: amount,
                    validity: validityStr,
                  ),
                  startDateText: DateFormat('dd MMM yyyy').format(startDate),
                  expiryDateText: DateFormat('dd MMM yyyy').format(endDate),
                  perDayCost: perDayCost,
                  totalPaid: amount,
                  completionPercentage: completion,
                  daysElapsed: elapsed.clamp(0, totalDuration),
                  totalDays: totalDuration,
                  onRenew: () {
                    // TODO: Implement renewal navigation
                  },
                  onViewInvoice: () {
                    // TODO: Implement invoice view
                  },
                  tags: const ['Index Option', 'Trader'],
                );
              }),

              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What\'s included:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              FeatureItem(icon: Icons.show_chart, text: 'Advanced Analytics'),
              const SizedBox(height: 12),
              FeatureItem(
                icon: Icons.all_inclusive,
                text: 'Unlimited Transactions',
              ),
              const SizedBox(height: 12),
              FeatureItem(icon: Icons.headset_mic, text: 'Priority Support'),
              const SizedBox(height: 12),
              FeatureItem(icon: Icons.security, text: 'Enhanced Security'),
              const SizedBox(height: 32),

              Button(
                title: 'Choose segment',
                buttonType: ButtonType.green,
                onTap: () {
                  Get.toNamed(AppRoutes.selectSegment);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
