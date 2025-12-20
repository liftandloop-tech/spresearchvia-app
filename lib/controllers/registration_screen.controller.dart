import 'package:get/get.dart';
import '../services/razorpay_payment_handler.dart';
import '../core/models/razorpay_options.dart';
import '../core/models/payment_callbacks.dart';
import '../controllers/plan_purchase.controller.dart';
import '../controllers/user.controller.dart';
import '../core/models/payment.options.dart';
import '../core/models/plan.dart';
import '../core/routes/app_routes.dart';
import '../services/snackbar.service.dart';
import '../services/payment_preference.service.dart';
import '../services/secure_storage.service.dart';

class RegistrationScreenController extends GetxController {
  final RxBool agreedToTerms = false.obs;
  final RxBool authorizedPayment = false.obs;
  final RxBool isProcessing = false.obs;
  final Rxn<String> currentPaymentId = Rxn<String>();
  final RxList<Plan> plans = <Plan>[].obs;
  final Rxn<Plan> selectedPlan = Rxn<Plan>();
  final Rxn<PaymentMethod> selectedPaymentMethod = Rxn<PaymentMethod>();

  final RazorpayPaymentHandler _paymentHandler = RazorpayPaymentHandler();
  final paymentPreferenceService = PaymentPreferenceService();
  final secureStorage = SecureStorageService();

  late final PlanPurchaseController planPurchaseController;
  late final UserController userController;

  @override
  void onInit() {
    super.onInit();

    if (!Get.isRegistered<PlanPurchaseController>()) {
      Get.put(PlanPurchaseController());
    }
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController());
    }

    planPurchaseController = Get.find<PlanPurchaseController>();
    userController = Get.find<UserController>();

    loadPlans();
    loadSavedPaymentMethod();
    checkPendingPayment();
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

  void checkPendingPayment() async {
    final pending = await secureStorage.getPendingPayment();
    if (pending != null) {
      final paymentId = pending['paymentId'];
      final orderId = pending['orderId'];

      SnackbarService.showInfo('Checking incomplete payment...');

      try {
        final success = await planPurchaseController.verifyPayment(
          paymentId: paymentId!,
          razorpayOrderId: orderId!,
          razorpayPaymentId: paymentId,
          razorpaySignature: '',
        );

        if (success) {
          await secureStorage.clearPendingPayment();
          SnackbarService.showSuccess('Previous payment verified!');
          await Future.delayed(const Duration(milliseconds: 500));
          Get.offAllNamed(AppRoutes.tabs);
        } else {
          await secureStorage.clearPendingPayment();
        }
      } catch (e) {
        Get.log('Error verifying pending payment: $e');
      }
    }
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
        await secureStorage.clearPendingPayment();
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
    await secureStorage.clearPendingPayment();
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
    await secureStorage.clearPendingPayment();
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
      final validity = plan.validityDays ?? 365;
      final cgstAmount = plan.cgstAmount;
      final sgstAmount = plan.sgstAmount;

      final orderData = await planPurchaseController.purchasePlan(
        packageName: planName,
        amount: amount,
        validity: validity,
        cgstAmount: cgstAmount,
        sgstAmount: sgstAmount,
      );

      currentPaymentId.value = orderData?['paymentId'];
      final razorpayOrderId = orderData?['razorpayOrderId'];

      if (razorpayOrderId == null) {
        throw Exception('Order ID not received from backend');
      }

      await secureStorage.savePendingPayment(
        paymentId: currentPaymentId.value!,
        orderId: razorpayOrderId,
      );

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
      await secureStorage.clearPendingPayment();
      SnackbarService.showError('Failed to initiate payment: ${e.toString()}');
    }
  }
}
