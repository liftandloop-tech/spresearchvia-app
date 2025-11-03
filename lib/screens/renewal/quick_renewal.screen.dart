import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/utils/custom_snackbar.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/screens/tabs.screen.dart';
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
    // Check if there's an active plan, redirect if none
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!planController.hasActivePlan) {
        Get.off(() => TabsScreen(initialIndex: 2));
      }
    });
    // Refresh plan data when screen opens
    planController.fetchUserPlan();
  }

  Future<void> _renewPlan() async {
    final plan = planController.currentPlan.value;
    if (plan == null) {
      CustomSnackbar.showWarning('No active plan found');
      return;
    }

    // Show loading
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
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
      final orderData = await planController.purchasePlan(
        packageName: plan.name,
        amount: plan.amount,
      );

      // Close loading dialog
      Get.back();

      if (orderData == null) {
        CustomSnackbar.showError(
          'Failed to create renewal order. Please try again.',
        );
        return;
      }

      // Show success and inform about payment
      CustomSnackbar.showSuccess(
        'Renewal order created successfully. You can now proceed with payment.',
        title: 'Order Created',
      );

      // Refresh plan data
      await planController.fetchUserPlan();
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      CustomSnackbar.showError('Failed to initiate renewal: ${e.toString()}');
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
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBlueDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
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
          return Center(child: CircularProgressIndicator());
        }

        if (plan == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.subscriptions_outlined,
                  size: 64,
                  color: AppTheme.borderGrey,
                ),
                SizedBox(height: 16),
                Text(
                  'No active plan found',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textGrey,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.off(() => TabsScreen(initialIndex: 2)),
                  child: Text('Browse Plans'),
                ),
              ],
            ),
          );
        }

        final daysRemaining = planController.daysRemaining;
        final validityText = plan.validityDays > 0
            ? '${plan.validityDays} days'
            : 'N/A';

        // Format expiry date as dd/MM/yyyy
        String expiryDateText = 'N/A';
        if (plan.expiryDate != null) {
          final expiry = plan.expiryDate!;
          expiryDateText =
              '${expiry.day.toString().padLeft(2, '0')}/${expiry.month.toString().padLeft(2, '0')}/${expiry.year}';
        }

        // Default benefits if none provided
        final benefits = plan.features.isNotEmpty
            ? plan.features
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
                // Show expiry warning - red if ≤7 days, neutral otherwise
                if (daysRemaining >= 0)
                  ExpiryWarningCard(
                    daysRemaining: daysRemaining,
                    message: daysRemaining > 7
                        ? 'Your plan is active'
                        : daysRemaining > 0
                        ? 'Renew now to continue accessing premium research'
                        : 'Your plan has expired. Renew to regain access',
                  ),
                if (daysRemaining >= 0) SizedBox(height: 24),
                SectionHeader(title: 'Current Plan'),
                SizedBox(height: 8),
                // Greeting with user name when available
                if (userController.currentUser.value != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      'Hello, ${userController.currentUser.value!.name}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),
                  ),
                SizedBox(height: 12),
                CurrentPlanCard(
                  planName: plan.name.isNotEmpty ? plan.name : 'Premium Plan',
                  description: plan.description.isNotEmpty
                      ? plan.description
                      : 'Full access to all reports',
                  price: '₹${plan.amount.toStringAsFixed(2)}/$validityText',
                  validity: validityText,
                  expiryDate: expiryDateText,
                ),
                SizedBox(height: 24),
                // Amount to pay summary
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
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
                        style: TextStyle(
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
                SizedBox(height: 24),
                BenefitsSection(benefits: benefits),
                SizedBox(height: 24),
                SecurePaymentFooter(),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
