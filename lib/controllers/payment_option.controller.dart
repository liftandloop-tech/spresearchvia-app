import 'package:get/get.dart';
import 'package:spresearchvia2/core/models/payment.options.dart';
import 'package:spresearchvia2/services/payment.service.dart';

class PaymentOptionController extends GetxController {
  final Rx<PaymentMethod?> selectedPaymentMethod = Rx<PaymentMethod?>(null);
  final Rx<SavedPaymentMethod?> savedPaymentMethod = Rx<SavedPaymentMethod?>(
    null,
  );
  final PaymentService _paymentService = PaymentService();

  @override
  void onInit() {
    super.onInit();
    loadSavedPaymentMethod();
  }

  void loadSavedPaymentMethod() {
    final saved = _paymentService.getSavedPaymentMethod();
    if (saved != null) {
      savedPaymentMethod.value = saved;
      selectedPaymentMethod.value = saved.method;
    }
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  bool isSelected(PaymentMethod method) {
    return selectedPaymentMethod.value == method;
  }

  Future<void> saveCurrentPaymentMethod({
    String? cardLast4,
    String? cardBrand,
    String? upiId,
    String? walletName,
  }) async {
    if (selectedPaymentMethod.value == null) return;

    final paymentMethod = SavedPaymentMethod(
      method: selectedPaymentMethod.value!,
      cardLast4: cardLast4,
      cardBrand: cardBrand,
      upiId: upiId,
      walletName: walletName,
      savedAt: DateTime.now(),
    );

    await _paymentService.savePaymentMethod(paymentMethod);
    savedPaymentMethod.value = paymentMethod;
  }

  Future<void> clearSavedPaymentMethod() async {
    await _paymentService.clearSavedPaymentMethod();
    savedPaymentMethod.value = null;
  }

  void reset() {
    selectedPaymentMethod.value = null;
  }

  bool get hasSelectedPaymentMethod => selectedPaymentMethod.value != null;
  bool get hasSavedPaymentMethod => savedPaymentMethod.value != null;
}
