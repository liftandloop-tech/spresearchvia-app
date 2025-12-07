import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/button.dart';
import '../../services/snackbar.service.dart';
import '../../features/payment/services/razorpay_payment_handler.dart';
import '../../features/payment/models/razorpay_options.dart';
import '../../features/payment/models/payment_callbacks.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../controllers/user.controller.dart';
import '../../core/routes/app_routes.dart';
import '../../controllers/segment_plan.controller.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final RxBool agreedToTerms = false.obs;
  final RxBool authorizedPayment = false.obs;
  final RxBool isProcessing = false.obs;
  final Rx<int> selectedPaymentMethod = 1.obs;
  final customAmountController = TextEditingController();

  final RxDouble baseAmount = 0.0.obs;
  final RxDouble gstAmount = 0.0.obs;
  final RxDouble totalPayable = 0.0.obs;
  final RxDouble perDayCost = 0.0.obs;
  final RxString perDayCostText = ''.obs;

  final RazorpayPaymentHandler _paymentHandler = RazorpayPaymentHandler();
  late final PlanPurchaseController planPurchaseController;
  late final UserController userController;
  SegmentPlan? selectedPlan;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<PlanPurchaseController>()) {
      Get.put(PlanPurchaseController());
    }
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController());
    }
    planPurchaseController = Get.find<PlanPurchaseController>();
    userController = Get.find<UserController>();

    final args = Get.arguments as Map<String, dynamic>?;
    selectedPlan = args?['plan'];

    if (selectedPlan != null) {
      _initializeValuesFromPlan();
    }

    customAmountController.addListener(_onCustomAmountChanged);
  }

  void _initializeValuesFromPlan() {
    if (selectedPlan == null) return;
    double amount = _parseAmountString(selectedPlan!.amount);
    _updateCalculations(amount);
  }

  void _onCustomAmountChanged() {
    String text = customAmountController.text.replaceAll(',', '').trim();
    if (text.isEmpty) {
      _initializeValuesFromPlan();
    } else {
      double? customAmount = double.tryParse(text);
      if (customAmount != null) {
        _updateCalculations(customAmount);
      }
    }
  }

  void _updateCalculations(double amount) {
    baseAmount.value = amount;
    gstAmount.value = amount * 0.18;
    totalPayable.value = amount + gstAmount.value;
    perDayCost.value = totalPayable.value / 365;
    perDayCostText.value = '₹${perDayCost.value.toStringAsFixed(0)}/day';
  }

  double _parseAmountString(String amountStr) {
    String cleanStr = amountStr.replaceAll('₹', '').replaceAll(',', '');
    if (cleanStr.toLowerCase().contains('lakh')) {
      cleanStr = cleanStr
          .toLowerCase()
          .replaceAll('lakh/year', '')
          .replaceAll('lakh', '')
          .trim();
      return double.parse(cleanStr) * 100000;
    }
    return double.tryParse(cleanStr) ?? 0.0;
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  void dispose() {
    customAmountController.dispose();
    _paymentHandler.dispose();
    super.dispose();
  }

  void handlePaymentSuccess(
    String paymentId,
    String orderId,
    String signature,
  ) async {
    try {
      SnackbarService.showSuccess('Payment completed successfully!');
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(AppRoutes.tabs);
    } catch (e) {
      SnackbarService.showError('Payment verification failed: ${e.toString()}');
    } finally {
      isProcessing.value = false;
    }
  }

  void handlePaymentError(String errorMessage) {
    isProcessing.value = false;
    SnackbarService.showError(errorMessage);
    Get.offAllNamed(
      AppRoutes.paymentFailure,
      arguments: {
        'message': errorMessage,
        'backRoute': AppRoutes.selectSegment,
      },
    );
  }

  void handleExternalWallet(String walletName) {
    isProcessing.value = false;
    SnackbarService.showInfo('Payment via $walletName');
  }

  Future<void> _proceedToPay() async {
    if (!agreedToTerms.value || !authorizedPayment.value) {
      SnackbarService.showWarning(
        'Please agree to the terms and authorize payment',
      );
      return;
    }

    if (selectedPlan == null) {
      SnackbarService.showError('Invalid plan selected');
      return;
    }

    isProcessing.value = true;

    try {
      final amount = totalPayable.value;

      final orderData = await planPurchaseController.purchasePlan(
        packageName: selectedPlan!.name,
        amount: amount,
      );

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
        planName: selectedPlan!.name,
        userEmail: userEmail,
        userPhone: userPhone,
        userName: userName,
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
      SnackbarService.showError('Failed to initiate payment: ${e.toString()}');
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
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Confirm Your Payment',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review your selected plan or enter a custom amount to proceed.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppTheme.textGrey,
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield, color: Color(0xFF10B981), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Secure Payment Gateway – 256-bit Encrypted',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Index Option – ${selectedPlan?.name ?? 'Splendid Plan'}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlueDark,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Change Plan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow('Duration', '1 Year'),
                  SizedBox(height: 8),
                  _buildDetailRow('Base Price', selectedPlan?.amount ?? '₹0'),
                  SizedBox(height: 8),
                  _buildDetailRow(
                    'Per-Day Cost',
                    selectedPlan?.perDay.split('\n')[0] ?? '',
                  ),
                  SizedBox(height: 8),
                  _buildDetailRow('Trader Type', 'Professional Trader'),
                ],
              ),
            ),
            SizedBox(height: 24),

            Row(
              children: [
                Icon(
                  Icons.business_center,
                  color: AppTheme.primaryBlueDark,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Custom Payment',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Enter Amount (₹)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textBlack,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: customAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'e.g., 75,000',
                hintStyle: TextStyle(color: AppTheme.textGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.borderGrey),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Approx per-day cost:',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                    ),
                    Text(
                      perDayCostText.value,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info, color: AppTheme.primaryBlue, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Custom payments are reviewed and approved by the ResearchVia compliance team.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            Text(
              'Payment Breakdown',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            SizedBox(height: 16),
            Obx(
              () => Column(
                children: [
                  _buildBreakdownRow(
                    'Subtotal',
                    _formatCurrency(baseAmount.value),
                  ),
                  SizedBox(height: 12),
                  _buildBreakdownRow(
                    'GST (18%)',
                    _formatCurrency(gstAmount.value),
                  ),
                  SizedBox(height: 12),
                  Divider(color: AppTheme.borderGrey),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payable',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                      Text(
                        _formatCurrency(totalPayable.value),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Text(
              'Payment Options',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            SizedBox(height: 16),
            _buildPaymentOption(1, 'Credit / Debit Card', Icons.credit_card),
            SizedBox(height: 12),
            _buildPaymentOption(
              2,
              'UPI (Google Pay, Paytm, PhonePe)',
              Icons.smartphone,
            ),
            SizedBox(height: 12),
            _buildPaymentOption(3, 'Net Banking', Icons.account_balance),
            SizedBox(height: 12),
            _buildPaymentOption(
              4,
              'EMI / Wallet',
              Icons.account_balance_wallet,
            ),
            SizedBox(height: 24),

            Obx(
              () => CheckboxListTile(
                value: agreedToTerms.value,
                onChanged: (val) => agreedToTerms.value = val ?? false,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppTheme.textGrey,
                    ),
                    children: [
                      TextSpan(text: 'I agree to the, '),
                      TextSpan(
                        text: 'Terms Refund Policy',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' and . '),
                      TextSpan(
                        text: 'Service Agreement',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                value: authorizedPayment.value,
                onChanged: (val) => authorizedPayment.value = val ?? false,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'I authorize SP ResearchVia Pvt. Ltd. to debit this amount securely.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            Obx(
              () => Button(
                title: isProcessing.value
                    ? 'Processing...'
                    : 'Proceed to Pay ${_formatCurrency(totalPayable.value)}',
                buttonType: ButtonType.green,
                onTap: isProcessing.value ? null : _proceedToPay,
                showLoading: isProcessing.value,
              ),
            ),
            SizedBox(height: 12),
            Button(
              title: 'Cancel / Go Back',
              buttonType: ButtonType.greyBorder,
              onTap: () => Get.back(),
            ),
            SizedBox(height: 24),

            Center(
              child: Column(
                children: [
                  Text(
                    'Powered by Razorpay Payment Gateway',
                    style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPaymentIcon('assets/icons/visa.png'),
                      SizedBox(width: 8),
                      _buildPaymentIcon('assets/icons/mastercard.png'),
                      SizedBox(width: 8),
                      Icon(Icons.lock, color: Color(0xFF10B981), size: 24),
                      SizedBox(width: 8),
                      Icon(Icons.credit_card, color: Colors.grey, size: 24),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'All transactions are encrypted and verified by PCI-DSS standards.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: AppTheme.textGrey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppTheme.textGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppTheme.textBlack,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(int value, String title, IconData icon) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedPaymentMethod.value == value
                ? AppTheme.primaryBlue
                : AppTheme.borderGrey,
          ),
          borderRadius: BorderRadius.circular(8),
          color: selectedPaymentMethod.value == value
              ? Color(0xFFF0F9FF)
              : Colors.white,
        ),
        child: RadioListTile<int>(
          value: value,
          groupValue: selectedPaymentMethod.value,
          onChanged: (val) => selectedPaymentMethod.value = val!,
          title: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selectedPaymentMethod.value == value
                    ? AppTheme.primaryBlue
                    : AppTheme.textGrey,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textBlack,
                  ),
                ),
              ),
            ],
          ),
          activeColor: AppTheme.primaryBlue,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          dense: true,
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(String assetPath) {
    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(Icons.payment, size: 12, color: Colors.grey[600]),
      ),
    );
  }
}
