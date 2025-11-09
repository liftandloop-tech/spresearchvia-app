import 'package:get/get.dart';

import '../../../controllers/payment_option.controller.dart';
import '../../../controllers/plan_purchase.controller.dart';
import '../../../controllers/plan_selection.controller.dart';
import '../../../controllers/user.controller.dart';
import '../../../core/base/base_controller.dart';
import '../../../services/snackbar.service.dart';
import '../../payment/models/payment_callbacks.dart';
import '../../payment/models/razorpay_options.dart';
import '../../payment/services/razorpay_payment_handler.dart';

/// ViewModel for subscription registration screen
class RegistrationViewModel extends BaseController {
  // Dependencies
  late final PaymentOptionController paymentController;
  late final PlanSelectionController planController;
  late final PlanPurchaseController planPurchaseController;
  late final UserController userController;
  late final RazorpayPaymentHandler _paymentHandler;

  // State
  final _isProcessing = false.obs;
  final _agreedToTerms = false.obs;
  final _authorizedPayment = false.obs;
  String? _currentPaymentId;

  // Getters
  bool get isProcessing => _isProcessing.value;
  bool get agreedToTerms => _agreedToTerms.value;
  bool get authorizedPayment => _authorizedPayment.value;
  bool get canProceedToPay => _agreedToTerms.value && _authorizedPayment.value;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _paymentHandler = RazorpayPaymentHandler();
  }

  void _initializeDependencies() {
    paymentController = Get.put(PaymentOptionController());
    planController = Get.put(PlanSelectionController());
    planPurchaseController = Get.put(PlanPurchaseController());
    userController = Get.put(UserController());
  }

  /// Toggle terms agreement
  void toggleTermsAgreement(bool value) {
    _agreedToTerms.value = value;
  }

  /// Toggle payment authorization
  void togglePaymentAuthorization(bool value) {
    _authorizedPayment.value = value;
  }

  /// Proceed to payment
  Future<void> proceedToPay() async {
    if (_isProcessing.value) return;
    if (!canProceedToPay) {
      SnackbarService.showWarning('Please accept terms and authorize payment');
      return;
    }

    _isProcessing.value = true;

    try {
      // Get plan details
      final planName = planController.selectedPlanName;
      final planAmount = planController.basePrice.toDouble();

      // Create order
      final orderData = await planPurchaseController.purchasePlan(
        packageName: planName,
        amount: planAmount,
      );

      if (orderData == null) {
        throw Exception('Failed to create order');
      }

      _currentPaymentId = orderData['paymentId'];
      final razorpayOrderId = orderData['razorpayOrderId'];

      if (razorpayOrderId == null) {
        throw Exception('Order ID not received from backend');
      }

      // Prepare payment options
      final user = userController.currentUser.value;
      final options = RazorpayOptions(
        orderId: razorpayOrderId,
        amount: planAmount,
        planName: planName,
        userEmail: user?.email ?? '',
        userPhone: user?.phone ?? '',
        userName: user?.name ?? 'User',
        hiddenMethod: paymentController.selectedPaymentMethod.value,
      );

      // Initiate payment
      _paymentHandler.initiatePayment(
        options: options,
        callbacks: PaymentCallbacks(
          onSuccess: _handlePaymentSuccess,
          onError: _handlePaymentError,
          onWallet: _handleExternalWallet,
        ),
      );
    } catch (e) {
      _isProcessing.value = false;
      _currentPaymentId = null;
      SnackbarService.showError('Failed to initiate payment: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(
    String paymentId,
    String orderId,
    String signature,
  ) async {
    try {
      final currentPaymentId = _currentPaymentId;
      if (currentPaymentId == null) {
        throw Exception('Payment ID not found');
      }

      final success = await planPurchaseController.verifyPayment(
        paymentId: currentPaymentId,
        razorpayOrderId: orderId,
        razorpayPaymentId: paymentId,
        razorpaySignature: signature,
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
      _isProcessing.value = false;
      _currentPaymentId = null;
    }
  }

  void _handlePaymentError(String errorMessage) {
    _isProcessing.value = false;
    _currentPaymentId = null;
    SnackbarService.showError(errorMessage);
  }

  void _handleExternalWallet(String walletName) {
    _isProcessing.value = false;
    _currentPaymentId = null;
    SnackbarService.showInfo('Payment via $walletName');
  }

  @override
  void onClose() {
    _paymentHandler.dispose();
    _isProcessing.close();
    _agreedToTerms.close();
    _authorizedPayment.close();
    super.onClose();
  }
}
