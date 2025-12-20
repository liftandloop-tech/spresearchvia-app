import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/plan.card.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/payment_option_selector.dart';
import '../../controllers/registration_screen.controller.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  final BoxDecoration decoration = const BoxDecoration(
    border: Border(top: BorderSide(color: AppTheme.borderGrey)),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationScreenController());

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.offAllNamed(AppRoutes.login);
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.maxFinite,
                  height: 60,
                  child: AppLogo(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Confirm Your Subscription',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete your payment to activate your\nResearchVia account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: AppTheme.primaryGreen, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'SSL Secured & PCI-DSS Compliant',
                      style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: controller.plans.map((plan) {
                        final isSelected =
                            controller.selectedPlan.value?.id == plan.id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: PlanCard(
                            planName: plan.name,
                            amount: plan.amount.toInt(),
                            validity: plan.validity,
                            selected: isSelected,
                            onTap: () => controller.selectedPlan.value = plan,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() {
                  final plan = controller.selectedPlan.value;
                  if (plan == null) return const SizedBox();

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        SummaryTile(
                          title: 'Base Price',
                          amount: plan.amount.toInt(),
                        ),
                        SummaryTile(
                          title: 'CGST (${plan.cgstPercent.toInt()}%)',
                          amount: plan.cgstAmount.toInt(),
                        ),
                        SummaryTile(
                          title: 'SGST (${plan.sgstPercent.toInt()}%)',
                          amount: plan.sgstAmount.toInt(),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppTheme.textGrey),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total Payable',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '₹${plan.totalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: PaymentOptionSelector(
                      key: ValueKey(controller.selectedPaymentMethod.value),
                      selectedMethod: controller.selectedPaymentMethod.value,
                      onChoose: controller.selectPaymentMethod,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          Checkbox(
                            value: controller.agreedToTerms.value,
                            onChanged: (bool? val) {
                              controller.agreedToTerms.value = val ?? false;
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'I agree to the "Terms Refund Policy" and "Service Agreement"',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Row(
                        children: [
                          Checkbox(
                            value: controller.authorizedPayment.value,
                            onChanged: (bool? val) {
                              controller.authorizedPayment.value = val ?? false;
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'I authorize SP ResearchVia Pvt. Ltd. to process this payment.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  final plan = controller.selectedPlan.value;
                  final amount = plan?.totalAmount.toInt() ?? 0;
                  return Button(
                    title: controller.isProcessing.value
                        ? 'Processing...'
                        : 'Proceed to Pay ₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    buttonType: ButtonType.green,
                    onTap: controller.isProcessing.value
                        ? null
                        : controller.proceedToPay,
                    showLoading: controller.isProcessing.value,
                  );
                }),
                const SizedBox(height: 5),
                const Text(
                  "You'll receive a digital invoice after successful payment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PaymentCardIcon(image: 'assets/icons/visa.png'),
                    SizedBox(width: 10),
                    PaymentCardIcon(image: 'assets/icons/mastercard.png'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "All payments are processed securely by Razorpay",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentCardIcon extends StatelessWidget {
  const PaymentCardIcon({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 27,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  const SummaryTile({super.key, required this.title, required this.amount});
  final String title;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$title:',
            style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '₹$amount',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
