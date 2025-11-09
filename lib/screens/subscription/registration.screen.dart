import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:spresearchvia2/controllers/payment_option.controller.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/controllers/plan_selection.controller.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/core/config/razorpay.config.dart';
import 'package:spresearchvia2/core/models/payment.options.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/screens/subscription/widgets/plan.card.dart';
import 'package:spresearchvia2/services/snackbar.service.dart';
import 'package:spresearchvia2/widgets/app_logo.dart';
import 'package:spresearchvia2/widgets/button.dart';

class SubscriptionConfirmScreen extends StatefulWidget {
  SubscriptionConfirmScreen({super.key});

  @override
  State<SubscriptionConfirmScreen> createState() =>
      _SubscriptionConfirmScreenState();
}

class _SubscriptionConfirmScreenState extends State<SubscriptionConfirmScreen> {
  final PaymentOptionController paymentController = Get.put(
    PaymentOptionController(),
  );

  final PlanSelectionController planController = Get.put(
    PlanSelectionController(),
  );

  final planPurchaseController = Get.put(PlanPurchaseController());
  final userController = Get.put(UserController());

  late Razorpay _razorpay;
  bool _isProcessing = false;
  String? _currentPaymentId;
  bool _agreedToTerms = false;
  bool _authorizedPayment = false;

  final BoxDecoration decoration = BoxDecoration(
    border: Border.all(color: AppTheme.borderGrey),
    borderRadius: BorderRadius.circular(12),
  );

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
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final paymentId = _currentPaymentId;
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
        await paymentController.saveCurrentPaymentMethod();

        SnackbarService.showSuccess('Payment completed successfully!');
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back();
      } else {
        SnackbarService.showError(
          'Payment verification failed. Please contact support.',
        );
      }
    } catch (e) {
      SnackbarService.showError('Payment verification failed: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessing = false;
        _currentPaymentId = null;
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    setState(() {
      _isProcessing = false;
      _currentPaymentId = null;
    });
    SnackbarService.showError(response.message ?? 'Payment was not completed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    setState(() {
      _isProcessing = false;
      _currentPaymentId = null;
    });
    SnackbarService.showInfo('Payment via ${response.walletName}');
  }

  Future<void> _proceedToPay() async {
    if (_isProcessing) return;

    if (!_agreedToTerms || !_authorizedPayment) {
      SnackbarService.showWarning(
        'Please agree to the terms and authorize payment to proceed',
      );
      return;
    }

    if (!paymentController.hasSelectedPaymentMethod) {
      SnackbarService.showWarning('Please select a payment method');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final planName = planController.selectedPlanName;
      final amount = planController.totalAmount.toDouble();

      final orderData = await planPurchaseController.purchasePlan(
        packageName: planName,
        amount: amount,
      );

      if (orderData == null) {
        throw Exception('Failed to create order');
      }

      _currentPaymentId = orderData['paymentId'];
      final razorpayOrderId = orderData['razorpayOrderId'];

      if (razorpayOrderId == null) {
        throw Exception('Order ID not received from backend');
      }

      final user = userController.currentUser.value;
      final userEmail = user?.email ?? '';
      final userPhone = user?.phone ?? '';
      final userName = user?.name ?? 'User';

      Map<String, dynamic> options = {
        'key': RazorpayConfig.keyId,
        'amount': (amount * 100).round(),
        'name': RazorpayConfig.companyName,
        'order_id': razorpayOrderId,
        'description': planName,
        'timeout': RazorpayConfig.timeout,
        'prefill': {'contact': userPhone, 'email': userEmail, 'name': userName},
        'theme': {'color': RazorpayConfig.themeColor},
        'readonly': {
          'email': userEmail.isNotEmpty,
          'contact': userPhone.isNotEmpty,
        },
        'modal': {
          'ondismiss': () {
            setState(() {
              _isProcessing = false;
              _currentPaymentId = null;
            });
          },
          'confirm_close': true,
        },
      };

      final selectedMethod = paymentController.selectedPaymentMethod.value;
      if (selectedMethod != null) {
        List<Map<String, String>> hiddenMethods = [];

        switch (selectedMethod) {
          case PaymentMethod.card:
            hiddenMethods = [
              {'method': 'upi'},
              {'method': 'netbanking'},
              {'method': 'wallet'},
              {'method': 'emi'},
              {'method': 'cardless_emi'},
              {'method': 'paylater'},
            ];
            break;
          case PaymentMethod.upi:
            hiddenMethods = [
              {'method': 'card'},
              {'method': 'netbanking'},
              {'method': 'wallet'},
              {'method': 'emi'},
              {'method': 'cardless_emi'},
              {'method': 'paylater'},
            ];
            break;
          case PaymentMethod.netBanking:
            hiddenMethods = [
              {'method': 'card'},
              {'method': 'upi'},
              {'method': 'wallet'},
              {'method': 'emi'},
              {'method': 'cardless_emi'},
              {'method': 'paylater'},
            ];
            break;
          case PaymentMethod.wallet:
            hiddenMethods = [
              {'method': 'card'},
              {'method': 'upi'},
              {'method': 'netbanking'},
              {'method': 'emi'},
              {'method': 'cardless_emi'},
              {'method': 'paylater'},
            ];
            break;
        }

        options['config'] = {
          'display': {
            'hide': hiddenMethods,
            'preferences': {'show_default_blocks': false},
          },
        };
      }

      _razorpay.open(options);
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _currentPaymentId = null;
      });
      SnackbarService.showError('Failed to initiate payment: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 100, child: AppLogo()),
              SizedBox(height: 10),
              Text(
                'Confirm Your Subscription',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Complete your payment to activate your ResearchVia account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: AppTheme.primaryGreen, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'SSL Secured & PCI-DSS Compliant',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Obx(
                () => Container(
                  decoration: decoration,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      PlanCard(
                        planName: planController
                            .planDetails[PlanType.annual]!['name'],
                        amount: planController
                            .planDetails[PlanType.annual]!['amount'],
                        validity: planController
                            .planDetails[PlanType.annual]!['validity'],
                        selected: planController.isSelected(PlanType.annual),
                        onTap: () => planController.selectPlan(PlanType.annual),
                      ),
                      SizedBox(height: 10),
                      PlanCard(
                        planName: planController
                            .planDetails[PlanType.oneTime]!['name'],
                        amount: planController
                            .planDetails[PlanType.oneTime]!['amount'],
                        validity: planController
                            .planDetails[PlanType.oneTime]!['validity'],
                        selected: planController.isSelected(PlanType.oneTime),
                        onTap: () =>
                            planController.selectPlan(PlanType.oneTime),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => Container(
                  decoration: decoration,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      SummaryTile(
                        title: 'Base Price',
                        amount: planController.basePrice,
                      ),
                      SummaryTile(
                        title: 'CGST (9%)',
                        amount: planController.cgstAmount,
                      ),
                      SummaryTile(
                        title: 'SGST (9%)',
                        amount: planController.sgstAmount,
                      ),
                      SizedBox(height: 10),
                      Divider(color: AppTheme.textGrey),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total Payable',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '₹${planController.formattedTotal}',
                            style: TextStyle(
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
              SizedBox(height: 20),
              Container(
                decoration: decoration,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 15),
                    ...PaymentOption.options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Obx(
                          () => PaymentMethodTile(
                            icon: option.icon,
                            title: option.title,
                            selected: paymentController.isSelected(
                              option.method,
                            ),
                            onTap: () => paymentController.selectPaymentMethod(
                              option.method,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (bool? val) {
                            setState(() {
                              _agreedToTerms = val ?? false;
                            });
                          },
                        ),
                        Expanded(
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _authorizedPayment,
                          onChanged: (bool? val) {
                            setState(() {
                              _authorizedPayment = val ?? false;
                            });
                          },
                        ),
                        Expanded(
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
                  ],
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => Button(
                  title: _isProcessing
                      ? 'Processing...'
                      : 'Proceed to Pay ₹${planController.formattedTotal}',
                  buttonType: ButtonType.green,
                  onTap: _isProcessing ? null : _proceedToPay,
                  showLoading: _isProcessing,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "You'll receive a digital invoice after successful payment.",
                style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PaymentCardIcon(image: 'assets/icons/visa.png'),
                  SizedBox(width: 10),
                  PaymentCardIcon(image: 'assets/icons/mastercard.png'),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "All payments are processed securely by Razorpay",
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
            style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
          ),
        ),
        SizedBox(width: 10),
        Text('₹$amount', style: TextStyle(fontSize: 14, color: Colors.black)),
      ],
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.backgroundLightBlue : Colors.white,
          border: Border.all(
            width: 2,
            color: selected ? AppTheme.primaryBlue : AppTheme.borderGrey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? AppTheme.primaryBlue : AppTheme.textGrey,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? AppTheme.primaryBlueDark
                      : AppTheme.textGrey,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppTheme.primaryBlue : Colors.white,
                border: Border.all(
                  color: selected ? AppTheme.primaryBlue : AppTheme.borderGrey,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
