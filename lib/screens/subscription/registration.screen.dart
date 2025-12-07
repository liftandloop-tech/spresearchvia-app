import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/payment/services/razorpay_payment_handler.dart';
import '../../features/payment/models/razorpay_options.dart';
import '../../features/payment/models/payment_callbacks.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../controllers/user.controller.dart';
import '../../core/models/payment.options.dart';
import '../../core/models/plan.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/plan.card.dart';
import '../../services/snackbar.service.dart';
import '../../services/payment_preference.service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/payment_option_selector.dart';

class RegistrationController extends GetxController {
  final RxBool agreedToTerms = false.obs;
  final RxBool authorizedPayment = false.obs;
  final RxBool isProcessing = false.obs;
  final Rxn<String> currentPaymentId = Rxn<String>();
  final RxList<Plan> plans = <Plan>[].obs;
  final Rxn<Plan> selectedPlan = Rxn<Plan>();
  final Rxn<PaymentMethod> selectedPaymentMethod = Rxn<PaymentMethod>();

  final RazorpayPaymentHandler _paymentHandler = RazorpayPaymentHandler();
  final paymentPreferenceService = PaymentPreferenceService();

  late final PlanPurchaseController planPurchaseController;
  late final UserController userController;

  @override
  void onInit() {
    super.onInit();

    print('🔵 RegistrationController onInit started');

    if (!Get.isRegistered<PlanPurchaseController>()) {
      Get.put(PlanPurchaseController());
    }
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController());
    }

    planPurchaseController = Get.find<PlanPurchaseController>();
    userController = Get.find<UserController>();

    print(
      '🔵 UserController currentUser: ${userController.currentUser.value?.fullName}',
    );

    loadPlans();
    loadSavedPaymentMethod();

    print('🔵 RegistrationController onInit completed');
  }

  void loadPlans() {
    plans.value = Plan.getMockPlans();
    if (plans.isNotEmpty) {
      selectedPlan.value = plans.first;
    }
  }

  void loadSavedPaymentMethod() {
    final method = paymentPreferenceService.getPaymentMethod();
    selectedPaymentMethod.value = method;
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
    paymentPreferenceService.savePaymentMethod(method);
  }

  @override
  void onClose() {
    _paymentHandler.dispose();
    super.onClose();
  }

  void handlePaymentSuccess(
    String paymentId,
    String orderId,
    String signature,
  ) async {
    try {
      final storedPaymentId = currentPaymentId.value;
      if (storedPaymentId == null) {
        throw Exception('Payment ID not found');
      }

      final success = await planPurchaseController.verifyPayment(
        paymentId: storedPaymentId,
        razorpayOrderId: orderId,
        razorpayPaymentId: paymentId,
        razorpaySignature: signature,
      );

      if (success) {
        SnackbarService.showSuccess('Payment completed successfully!');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.tabs);
      } else {
        SnackbarService.showError(
          'Payment verification failed. Please contact support.',
        );
        Get.offAllNamed(AppRoutes.paymentFailure);
      }
    } catch (e) {
      SnackbarService.showError('Payment verification failed: ${e.toString()}');
    } finally {
      isProcessing.value = false;
      currentPaymentId.value = null;
    }
  }

  void handlePaymentError(String errorMessage) async {
    isProcessing.value = false;
    currentPaymentId.value = null;
    SnackbarService.showError(errorMessage);
    Get.offAllNamed(
      AppRoutes.paymentFailure,
      arguments: {
        'message': errorMessage,
        'backRoute': AppRoutes.registrationScreen,
      },
    );
  }

  void handleExternalWallet(String walletName) async {
    isProcessing.value = false;
    currentPaymentId.value = null;
    SnackbarService.showInfo('Payment via $walletName');
  }

  Future<void> proceedToPay() async {
    if (isProcessing.value) return;

    if (!agreedToTerms.value || !authorizedPayment.value) {
      SnackbarService.showWarning(
        'Please agree to the terms and authorize payment to proceed',
      );
      return;
    }

    if (selectedPlan.value == null) {
      SnackbarService.showError('Please select a plan');
      return;
    }

    if (selectedPaymentMethod.value == null) {
      SnackbarService.showError('Please select a payment method');
      return;
    }

    isProcessing.value = true;

    try {
      final plan = selectedPlan.value!;
      final planName = plan.name;
      final amount = plan.totalAmount;

      final orderData = await planPurchaseController.purchasePlan(
        packageName: planName,
        amount: amount,
      );

      currentPaymentId.value = orderData?['paymentId'];
      final razorpayOrderId = orderData?['razorpayOrderId'];

      if (razorpayOrderId == null) {
        throw Exception('Order ID not received from backend');
      }

      final user = userController.currentUser.value;
      final userEmail = user?.email ?? '';
      final userPhone = user?.phone ?? '';
      final userName = user?.name ?? 'User';

      final options = RazorpayOptions(
        orderId: razorpayOrderId,
        amount: amount,
        planName: planName,
        userEmail: userEmail,
        userPhone: userPhone,
        userName: userName,
        hiddenMethod: selectedPaymentMethod.value,
      );

      _paymentHandler.initiatePayment(
        options: options,
        callbacks: PaymentCallbacks(
          onSuccess: handlePaymentSuccess,
          onError: handlePaymentError,
          onWallet: handleExternalWallet,
        ),
      );
    } catch (e) {
      isProcessing.value = false;
      currentPaymentId.value = null;
      SnackbarService.showError('Failed to initiate payment: ${e.toString()}');
    }
  }
}

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  final BoxDecoration decoration = const BoxDecoration(
    border: Border(top: BorderSide(color: AppTheme.borderGrey)),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());

    print('🟢 RegistrationScreen build() called');

    return PopScope(
      canPop: false,
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
                Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
