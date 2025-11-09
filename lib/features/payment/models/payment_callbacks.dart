/// Payment result callback types
typedef PaymentSuccessCallback =
    void Function(String paymentId, String orderId, String signature);
typedef PaymentErrorCallback = void Function(String errorMessage);
typedef PaymentWalletCallback = void Function(String walletName);

/// Payment callbacks container
class PaymentCallbacks {
  final PaymentSuccessCallback onSuccess;
  final PaymentErrorCallback onError;
  final PaymentWalletCallback? onWallet;

  PaymentCallbacks({
    required this.onSuccess,
    required this.onError,
    this.onWallet,
  });
}
