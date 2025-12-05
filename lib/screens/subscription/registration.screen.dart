import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../controllers/user.controller.dart';
import '../../core/models/payment.options.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/plan.card.dart';
import '../../services/snackbar.service.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/payment_option_selector.dart';

class RegistrationController extends GetxController {
  final RxBool agreedToTerms = false.obs;
  final RxBool authorizedPayment = false.obs;
  final RxBool isProcessing = false.obs;
  final Rxn<String> currentPaymentId = Rxn<String>();

  late Razorpay razorpay;

  late final PlanPurchaseController planPurchaseController;
  late final UserController userController;

  @override
  void onInit() {
    super.onInit();

    planPurchaseController = Get.find<PlanPurchaseController>();
    userController = Get.find<UserController>();

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final paymentId = currentPaymentId.value;
      if (paymentId == null) {
        throw Exception('Payment ID not found');
      }

      final success = await planPurchaseController.verifyPayment(
        paymentId: paymentId,
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );

      if (success) {
        SnackbarService.showSuccess('Payment completed successfully!');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed('/payment-success');
      } else {
        SnackbarService.showError(
          'Payment verification failed. Please contact support.',
        );
        Get.offAllNamed('/payment-failure');
      }
    } catch (e) {
      SnackbarService.showError('Payment verification failed: ${e.toString()}');
    } finally {
      isProcessing.value = false;
      currentPaymentId.value = null;
    }
  }

  void handlePaymentError(PaymentFailureResponse response) async {
    isProcessing.value = false;
    currentPaymentId.value = null;
    SnackbarService.showError(response.message ?? 'Payment was not completed');
    Get.offAllNamed('/payment-failure');
  }

  void handleExternalWallet(ExternalWalletResponse response) async {
    isProcessing.value = false;
    currentPaymentId.value = null;
    SnackbarService.showInfo('Payment via ${response.walletName}');
  }

  Future<void> proceedToPay() async {
    if (isProcessing.value) return;

    if (!agreedToTerms.value || !authorizedPayment.value) {
      SnackbarService.showWarning(
        'Please agree to the terms and authorize payment to proceed',
      );
      return;
    }

    isProcessing.value = true;

    try {
      final planName = 'Annual Plan';
      final amount = 5900.0;

      final orderData = await planPurchaseController.purchasePlan(
        packageName: planName,
        amount: amount,
      );

      if (orderData == null) {
        throw Exception('Failed to create order');
      }

      currentPaymentId.value = orderData['paymentId'];
      final razorpayOrderId = orderData['razorpayOrderId'];

      if (razorpayOrderId == null) {
        throw Exception('Order ID not received from backend');
      }

      // Use actual Razorpay payment gateway
      final user = userController.currentUser.value;
      final userEmail = user?.email ?? '';
      final userPhone = user?.phone ?? '';
      final userName = user?.name ?? 'User';

      Map<String, dynamic> options = {
        'key':
            'rzp_live_RQWUApgnu01KES', // Production Razorpay key from backend .env
        'amount': (amount * 100).round(),
        'name': 'SP ResearchVia',
        'order_id': razorpayOrderId,
        'description': planName,
        'timeout': 300,
        'prefill': {'contact': userPhone, 'email': userEmail, 'name': userName},
        'theme': {'color': '#163174'},
        'readonly': {
          'email': userEmail.isNotEmpty,
          'contact': userPhone.isNotEmpty,
        },
        'modal': {
          'ondismiss': () {
            isProcessing.value = false;
            currentPaymentId.value = null;
          },
          'confirm_close': true,
        },
      };

      razorpay.open(options);
    } catch (e) {
      isProcessing.value = false;
      currentPaymentId.value = null;
      SnackbarService.showError('Failed to initiate payment: ${e.toString()}');
    }
  }
}

class SubscriptionConfirmScreen extends StatelessWidget {
  const SubscriptionConfirmScreen({super.key});

  final BoxDecoration decoration = const BoxDecoration(
    border: Border(top: BorderSide(color: AppTheme.borderGrey)),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60, child: AppLogo()),
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
                    children: [
                      PlanCard(
                        planName: 'Annual Plan',
                        amount: 5000,
                        validity: '1 Year Access – Renew Annually',
                        selected: true,
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      PlanCard(
                        planName: 'One-Time Plan',
                        amount: 10000,
                        validity: 'Lifetime Access – Pay Once',
                        selected: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
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
                    children: [
                      SummaryTile(title: 'Base Price', amount: 5000),
                      SummaryTile(title: 'CGST (9%)', amount: 450),
                      SummaryTile(title: 'SGST (9%)', amount: 450),
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
                            '₹5,900',
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
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(15),
                child: Obx(
                  () => PaymentOptionSelector(
                    selectedMethod: null,
                    onChoose: (PaymentMethod method) {},
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
              Obx(
                () => Button(
                  title: controller.isProcessing.value
                      ? 'Processing...'
                      : 'Proceed to Pay ₹5,900',
                  buttonType: ButtonType.green,
                  onTap: controller.isProcessing.value
                      ? null
                      : controller.proceedToPay,
                  showLoading: controller.isProcessing.value,
                ),
              ),
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
