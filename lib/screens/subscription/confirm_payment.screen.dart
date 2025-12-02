import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/button.dart';
import '../../services/snackbar.service.dart';
import '../../services/storage.service.dart';
import '../../controllers/user.controller.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final RxBool agreedToTerms = false.obs;
  final RxBool authorizedPayment = false.obs;
  final RxBool isProcessing = false.obs;
  final Rx<int> selectedPaymentMethod = 1.obs; // 0=Card, 1=UPI, 2=NetBanking, 3=Wallet
  final customAmountController = TextEditingController();

  @override
  void dispose() {
    customAmountController.dispose();
    super.dispose();
  }

  Future<void> _proceedToPay() async {
    if (!agreedToTerms.value || !authorizedPayment.value) {
      SnackbarService.showWarning('Please agree to the terms and authorize payment');
      return;
    }

    isProcessing.value = true;

    try {
      // Mock payment processing
      await Future.delayed(Duration(seconds: 2));

      // Save login state
      final storage = StorageService();
      final userController = Get.find<UserController>();
      await storage.setLoggedIn(true);
      await storage.saveAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      await storage.saveUserData({
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'name': userController.currentUser.value?.name ?? 'User',
        'email': userController.currentUser.value?.email ?? '',
        'phone': userController.currentUser.value?.phone ?? '',
      });

      isProcessing.value = false;
      SnackbarService.showSuccess('Payment completed successfully!');
      Get.offAllNamed('/payment-success');
    } catch (e) {
      isProcessing.value = false;
      SnackbarService.showError('Failed to process payment: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final plan = args?['plan'];

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

            // Secure Gateway Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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

            // Plan Details
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
                      Text(
                        'Index Option – ${plan?.name ?? 'Splendid Plan'}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlueDark,
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
                  _buildDetailRow('Base Price', '₹1,51,000'),
                  SizedBox(height: 8),
                  _buildDetailRow('Per-Day Cost', '₹415/day'),
                  SizedBox(height: 8),
                  _buildDetailRow('Trader Type', 'Professional Trader'),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Custom Payment Section
            Text(
              '💳 Custom Payment',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: customAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'e.g., 75,000',
                hintStyle: TextStyle(color: AppTheme.textGrey),
                labelText: 'Enter Amount (₹)',
                labelStyle: TextStyle(color: AppTheme.primaryBlueDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Approx per-day cost: ₹414/day',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Custom payments are reviewed and approved by the ResearchVia compliance team.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: AppTheme.textGrey,
              ),
            ),
            SizedBox(height: 24),

            // Payment Breakdown
            Text(
              'Payment Breakdown',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            SizedBox(height: 12),
            _buildPriceRow('Subtotal', '₹151,000'),
            SizedBox(height: 8),
            _buildPriceRow('GST (18%)', '₹27,180'),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payable',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
                Text(
                  '₹178,180',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Payment Options
            Text(
              'Payment Options',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            SizedBox(height: 12),
            Obx(() => Column(
              children: [
                _buildPaymentOption(0, Icons.credit_card, 'Credit / Debit Card'),
                SizedBox(height: 8),
                _buildPaymentOption(1, Icons.phone_android, 'UPI (Google Pay, Paytm, PhonePe)'),
                SizedBox(height: 8),
                _buildPaymentOption(2, Icons.account_balance, 'Net Banking'),
                SizedBox(height: 8),
                _buildPaymentOption(3, Icons.account_balance_wallet, 'EMI / Wallet'),
              ],
            )),
            SizedBox(height: 24),

            // Terms
            Obx(() => CheckboxListTile(
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
            )),
            Obx(() => CheckboxListTile(
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
            )),
            SizedBox(height: 24),

            // Proceed Button
            Obx(() => Button(
              title: isProcessing.value ? 'Processing...' : 'Proceed to Pay ₹178,180',
              buttonType: ButtonType.green,
              onTap: isProcessing.value ? null : _proceedToPay,
              showLoading: isProcessing.value,
            )),
            SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel / Go Back',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppTheme.textGrey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Footer
            Center(
              child: Text(
                'Powered by Razorpay Payment Gateway',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppTheme.textGrey,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/visa.png', width: 30, height: 20),
                SizedBox(width: 8),
                Image.asset('assets/icons/mastercard.png', width: 30, height: 20),
              ],
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                'All transactions are encrypted and verified by PCI-DSS standards.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: AppTheme.textGrey,
                ),
              ),
            ),
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

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppTheme.textGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(int index, IconData icon, String label) {
    final isSelected = selectedPaymentMethod.value == index;
    return InkWell(
      onTap: () => selectedPaymentMethod.value = index,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Color(0xFFF0F9FF) : Colors.white,
        ),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: selectedPaymentMethod.value,
              onChanged: (val) => selectedPaymentMethod.value = val ?? index,
              activeColor: AppTheme.primaryBlue,
            ),
            Icon(icon, color: AppTheme.primaryBlueDark, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
