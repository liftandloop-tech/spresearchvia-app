import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/base_view.dart';
import '../../../core/models/payment.options.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/button.dart';
import '../viewmodels/registration_viewmodel.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/plan_selector.dart';
import '../widgets/subscription_header.dart';
import '../widgets/terms_section.dart';

/// Registration/Subscription confirmation view
class RegistrationView extends BaseView<RegistrationViewModel> {
  const RegistrationView({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              // Logo
              SizedBox(height: 100, child: AppLogo()),
              const SizedBox(height: 10),

              // Header
              const SubscriptionHeader(
                title: 'Confirm Your Subscription',
                subtitle:
                    'Complete your payment to activate your ResearchVia account.',
              ),
              const SizedBox(height: 20),

              // Plan Selector
              Obx(() => PlanSelector(controller: controller.planController)),
              const SizedBox(height: 20),

              // Payment Summary
              Obx(
                () => PaymentSummaryCard(
                  basePrice: controller.planController.basePrice,
                  cgstAmount: controller.planController.cgstAmount,
                  sgstAmount: controller.planController.sgstAmount,
                  totalAmount: controller.planController.totalAmount,
                ),
              ),
              const SizedBox(height: 20),

              // Payment Method Selection
              _buildPaymentMethodSection(),
              const SizedBox(height: 20),

              // Terms & Conditions
              Obx(
                () => TermsSection(
                  agreedToTerms: controller.agreedToTerms,
                  authorizedPayment: controller.authorizedPayment,
                  onTermsChanged: controller.toggleTermsAgreement,
                  onAuthorizationChanged: controller.togglePaymentAuthorization,
                ),
              ),
              const SizedBox(height: 30),

              // Proceed Button
              Obx(
                () => Button(
                  title: controller.isProcessing
                      ? 'Processing...'
                      : 'Proceed To Pay',
                  buttonType: ButtonType.green,
                  onTap: controller.isProcessing || !controller.canProceedToPay
                      ? null
                      : controller.proceedToPay,
                ),
              ),
              const SizedBox(height: 20),

              // Security Footer
              _buildSecurityFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          Obx(
            () => Column(
              children: [
                _buildPaymentOption(
                  icon: Icons.credit_card,
                  title: 'Card',
                  subtitle: 'Debit/Credit Card',
                  isSelected:
                      controller
                          .paymentController
                          .selectedPaymentMethod
                          .value ==
                      PaymentMethod.card,
                  onTap: () => controller.paymentController.selectPaymentMethod(
                    PaymentMethod.card,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGreen.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: AppTheme.textGrey, size: 16),
            const SizedBox(width: 6),
            Text(
              'Powered by Razorpay',
              style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Your payment information is secure and encrypted',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: AppTheme.textGrey),
        ),
      ],
    );
  }
}
