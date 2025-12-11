import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../services/snackbar.service.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../controllers/user.controller.dart';
import 'widgets/benefits.section.dart';
import 'widgets/current_plan_card.dart';
import 'widgets/expiry_warning_card.dart';
import 'widgets/renew_button.dart';
import 'widgets/section_header.dart';
import 'widgets/security.footer.dart';

class QuickRenewalScreen extends StatefulWidget {
  const QuickRenewalScreen({super.key});

  @override
  State<QuickRenewalScreen> createState() => _QuickRenewalScreenState();
}

class _QuickRenewalScreenState extends State<QuickRenewalScreen> {
  final planController = Get.find<PlanPurchaseController>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    planController.fetchUserPlan();
  }

  Future<void> _renewPlan() async {
    final plan = planController.currentPlan.value;
    if (plan == null) {
      SnackbarService.showWarning('No active plan found');
      return;
    }

    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Creating order...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await planController.purchasePlan(
        packageName: plan.name,
        amount: plan.amount,
        validity: plan.validityDays ?? 365,
      );

      Get.back();

      SnackbarService.showSuccess(
        'Renewal order created successfully. You can now proceed with payment.',
        title: 'Order Created',
      );

      await planController.fetchUserPlan();
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlueDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Quick Renewal',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final plan = planController.currentPlan.value;
        final isLoading = planController.isLoading.value;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (plan == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.subscriptions_outlined,
                  size: 64,
                  color: AppTheme.borderGrey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No active plan found',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.offAllNamed('/tabs', arguments: 2),
                  child: const Text('Browse Plans'),
                ),
              ],
            ),
          );
        }

        final daysRemaining = planController.daysRemaining;
        final validityText = plan.validityDays != null && plan.validityDays! > 0
            ? '${plan.validityDays} days'
            : 'N/A';

        String expiryDateText = 'N/A';
        if (plan.expiryDate != null) {
          final expiry = plan.expiryDate!;
          expiryDateText =
              '${expiry.day.toString().padLeft(2, '0')}/${expiry.month.toString().padLeft(2, '0')}/${expiry.year}';
        }

        final benefits = (plan.features?.isNotEmpty ?? false)
            ? plan.features!
            : [
                'Access to all premium research reports',
                'Real-time market alerts and notifications',
                'Priority customer support',
                'Advanced portfolio analytics',
              ];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (daysRemaining >= 0)
                  ExpiryWarningCard(
                    daysRemaining: daysRemaining,
                    message: daysRemaining > 7
                        ? 'Your plan is active'
                        : daysRemaining > 0
                        ? 'Renew now to continue accessing premium research'
                        : 'Your plan has expired. Renew to regain access',
                  ),
                if (daysRemaining >= 0) const SizedBox(height: 24),
                const SectionHeader(title: 'Current Plan'),
                const SizedBox(height: 8),

                if (userController.currentUser.value != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      'Hello, ${userController.currentUser.value!.name}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                CurrentPlanCard(
                  planName: plan.name.isNotEmpty ? plan.name : 'Premium Plan',
                  description: plan.description?.isNotEmpty == true
                      ? plan.description!
                      : 'Full access to all reports',
                  price: '₹${plan.amount.toStringAsFixed(2)}/$validityText',
                  validity: validityText,
                  expiryDate: expiryDateText,
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount to pay',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textGrey,
                        ),
                      ),
                      Text(
                        plan.amount > 0
                            ? '₹${plan.amount.toStringAsFixed(2)}'
                            : 'Free',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                    ],
                  ),
                ),

                RenewButton(onPressed: _renewPlan),
                const SizedBox(height: 24),
                BenefitsSection(benefits: benefits),
                const SizedBox(height: 24),
                const SecurePaymentFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
