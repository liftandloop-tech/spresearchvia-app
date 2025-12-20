import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../core/models/payment_callbacks.dart';
import '../core/models/razorpay_options.dart';

class RazorpayPaymentHandler {
  late final Razorpay _razorpay;
  PaymentCallbacks? _callbacks;

  RazorpayPaymentHandler() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void initiatePayment({
    required RazorpayOptions options,
    required PaymentCallbacks callbacks,
  }) {
    _callbacks = callbacks;
    _razorpay.open(options.toMap());
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_callbacks != null) {
      _callbacks!.onSuccess(
        response.paymentId ?? '',
        response.orderId ?? '',
        response.signature ?? '',
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (_callbacks != null) {
      final errorMessage = response.message ?? 'Payment failed';
      _callbacks!.onError(errorMessage);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_callbacks != null && _callbacks!.onWallet != null) {
      _callbacks!.onWallet!(response.walletName ?? 'Unknown Wallet');
    }
  }

  void dispose() {
    _razorpay.clear();
    _callbacks = null;
  }
}
