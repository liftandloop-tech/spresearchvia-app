import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../controllers/user.controller.dart';
import '../../services/snackbar.service.dart';
import '../../widgets/button.dart';
import '../../widgets/active_plan_card.dart';
import '../../widgets/expiry_warning_banner.dart';
import '../../widgets/payment_method_card.dart';
import '../../widgets/benefits_card.dart';
import '../../widgets/secure_payment_footer.dart';
import '../../widgets/section_header.dart';

class QuickRenewalScreen extends StatefulWidget {
  const QuickRenewalScreen({super.key});

  @override
  State<QuickRenewalScreen> createState() => _QuickRenewalScreenState();
}

class _QuickRenewalScreenState extends State<QuickRenewalScreen> {
  final planController = Get.find<PlanPurchaseController>();
  final userController = Get.find<UserController>();

  PaymentMethodData? savedPaymentMethod;
  bool isLoadingPayment = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethod();
    planController.fetchUserPlan();
  }

  Future<void> _loadPaymentMethod() async {
    setState(() {
      savedPaymentMethod = null;
      isLoadingPayment = false;
    });
  }

  Future<void> _renewPlan() async {
    final plan = planController.currentPlan.value;
    if (plan == null) {
      SnackbarService.showError('No active plan found');
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
                'Processing payment...',
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
      );

      Get.back();

      SnackbarService.showSuccess('Redirecting to payment gateway...');
      Get.toNamed('/registration');
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  onPressed: () => Get.offAllNamed('/tabs', arguments: 2),
                  child: Text('Browse Plans'),
                ),
              ],
            ),
          );
        }

        final daysRemaining = planController.daysRemaining;
        final startDateText = DateFormatter.formatDate(plan.purchaseDate);
        final expiryDateText = DateFormatter.formatDate(plan.expiryDate);
        final totalPaid = plan.amount;
        final validityDays = plan.validityDays ?? 1;
        final perDayCost = validityDays > 0
            ? (totalPaid / validityDays).round()
            : 0;
        final completionPercentage = validityDays > 0
            ? (((validityDays - daysRemaining) / validityDays * 100)
                  .clamp(0, 100)
                  .toInt())
            : 0;
        final benefits = (plan.features?.isNotEmpty ?? false)
            ? plan.features!
            : [
                'Unlimited research reports',
                'Real-time market data',
                'Expert analysis & insights',
              ];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (daysRemaining <= 7) ...{
                  ExpiryWarningBanner(
                    daysRemaining: daysRemaining,
                    message: 'Renew now to continue accessing premium research',
                  ),
                  const SizedBox(height: 20),
                },
                const SectionHeader(title: 'Current Plan'),
                const SizedBox(height: 16),
                ActivePlanCard(
                  plan: plan,
                  startDateText: startDateText,
                  expiryDateText: expiryDateText,
                  perDayCost: perDayCost,
                  totalPaid: totalPaid,
                  completionPercentage: completionPercentage,
                  onRenew: _renewPlan,
                  onViewInvoice: () {},
                  tags: const ['Index Option', 'Trader'],
                ),
                const SizedBox(height: 20),
                const SectionHeader(title: 'Payment Method'),
                const SizedBox(height: 12),
                _buildPaymentMethodSection(),
                const SizedBox(height: 24),
                Button(
                  title: 'Renew with One Click',
                  buttonType: ButtonType.green,
                  onTap: _renewPlan,
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Get.offAllNamed('/tabs', arguments: 2),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlueDark,
                    side: BorderSide(color: AppTheme.primaryBlue),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Change Plan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BenefitsCard(benefits: benefits),
                const SizedBox(height: 24),
                const Center(child: SecurePaymentFooter()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPaymentMethodSection() {
    if (isLoadingPayment) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (savedPaymentMethod == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            const Icon(Icons.payment, size: 48, color: AppTheme.textGrey),
            const SizedBox(height: 12),
            const Text(
              'No payment method saved',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                SnackbarService.showInfo(
                  'Add payment method feature will be available soon',
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Payment Method'),
            ),
          ],
        ),
      );
    }

    return PaymentMethodCard(
      paymentMethod: savedPaymentMethod!,
      onTap: () {
        SnackbarService.showInfo(
          'Change payment method feature will be available soon',
        );
      },
    );
  }
}
