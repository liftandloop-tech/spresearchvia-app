import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/core/config/razorpay.config.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/screens/subscription/widgets/plan.card.dart';
import 'package:spresearchvia2/widgets/button.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  int selectedPlan = 1;
  final TextEditingController controller = TextEditingController();
  late Razorpay _razorpay;
  final planController = Get.find<PlanPurchaseController>();
  final userController = Get.find<UserController>();
  bool _isProcessing = false;
  String? _currentPaymentId; // Store payment ID for verification

  final List<List<dynamic>> plans = [
    ['Basic Plan', 299, 30, false],
    ['Premium Plan', 899, 90, true],
    ['Professional Plan', 1599, 180, false],
  ];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    controller.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment Success: ${response.paymentId}');

    // Verify payment with backend
    try {
      // Extract the paymentId that was stored when creating the order
      final paymentId = _currentPaymentId;
      if (paymentId == null) {
        throw Exception('Payment ID not found');
      }

      final success = await planController.verifyPayment(
        paymentId: paymentId,
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Payment completed successfully!',
          backgroundColor: AppTheme.success,
          colorText: AppTheme.textWhite,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate back or to success screen
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Payment verification failed. Please contact support.',
          backgroundColor: AppTheme.error,
          colorText: AppTheme.textWhite,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Payment verification failed: ${e.toString()}',
        backgroundColor: AppTheme.error,
        colorText: AppTheme.textWhite,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    setState(() => _isProcessing = false);

    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment was not completed',
      backgroundColor: AppTheme.error,
      colorText: AppTheme.textWhite,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    setState(() => _isProcessing = false);

    Get.snackbar(
      'External Wallet',
      'Payment via ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _proceedToPay() async {
    if (_isProcessing) return;

    // Get selected plan details
    String planName;
    double amount;

    if (selectedPlan < plans.length) {
      planName = plans[selectedPlan][0];
      amount = plans[selectedPlan][1].toDouble();
    } else {
      // Custom plan
      final customDays = int.tryParse(controller.text);
      if (customDays == null || customDays <= 0) {
        Get.snackbar(
          'Error',
          'Please enter a valid number of days',
          backgroundColor: AppTheme.error,
          colorText: AppTheme.textWhite,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      planName = 'Custom Plan';
      amount = customDays * 10.0; // Example: ₹10 per day
    }

    setState(() => _isProcessing = true);

    try {
      // Create order on backend
      final orderData = await planController.purchasePlan(
        packageName: planName,
        amount: amount,
      );

      if (orderData == null) {
        throw Exception('Failed to create order');
      }

      // Store payment ID for verification
      _currentPaymentId = orderData['paymentId'];

      // Get Razorpay order ID from response
      final razorpayOrderId = orderData['razorpayOrderId'];

      if (razorpayOrderId == null) {
        throw Exception('Order ID not received from backend');
      }

      // Get user details
      final user = userController.currentUser.value;
      final userEmail = user?.email ?? '';
      final userPhone = user?.phone ?? '';
      final userName = user?.name ?? 'User';

      // Open Razorpay payment gateway
      var options = {
        'key': RazorpayConfig.keyId,
        'amount': (amount * 100).toInt(), // Amount in paise
        'name': RazorpayConfig.companyName,
        'order_id': razorpayOrderId,
        'description': planName,
        'timeout': RazorpayConfig.timeout,
        'prefill': {'contact': userPhone, 'email': userEmail, 'name': userName},
        'theme': {'color': RazorpayConfig.themeColor},
      };

      _razorpay.open(options);
    } catch (e) {
      setState(() => _isProcessing = false);
      Get.snackbar(
        'Error',
        'Failed to initiate payment: ${e.toString()}',
        backgroundColor: AppTheme.error,
        colorText: AppTheme.textWhite,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan Details',
          style: TextStyle(
            color: Color(0xff11416B),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(
                color: Color(0xff11416B),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            for (int i = 0; i < plans.length; i++) ...[
              PlanCard(
                planName: plans[i][0],
                amount: plans[i][1],
                validity: plans[i][2],
                popular: plans[i][3],
                selected: selectedPlan == i,
                onTap: () => setState(() => selectedPlan = i),
              ),
              const SizedBox(height: 7),
            ],

            CustomPlanCard(
              selected: selectedPlan == plans.length,
              controller: controller,
              onTap: () => setState(() => selectedPlan = plans.length),
            ),

            const SizedBox(height: 25),

            const Text(
              'What’s Included',
              style: TextStyle(
                color: Color(0xff11416B),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            const WhatsNewItem(title: 'Unlimited research reports'),
            const WhatsNewItem(title: 'Real-time market data'),
            const WhatsNewItem(title: 'Expert analysis and insights'),
            const WhatsNewItem(title: '24/7 customer support'),

            const SizedBox(height: 30),

            Button(
              title: _isProcessing ? 'Processing...' : 'Proceed To Pay',
              buttonType: ButtonType.green,
              onTap: _isProcessing ? null : _proceedToPay,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class WhatsNewItem extends StatelessWidget {
  const WhatsNewItem({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xff2C7F38), size: 18),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
