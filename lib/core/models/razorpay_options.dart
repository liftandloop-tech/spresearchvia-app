import '../config/razorpay.config.dart';
import 'payment.options.dart';

class RazorpayOptions {
  final String orderId;
  final double amount;
  final String planName;
  final String userEmail;
  final String userPhone;
  final String userName;
  final PaymentMethod? hiddenMethod;

  RazorpayOptions({
    required this.orderId,
    required this.amount,
    required this.planName,
    required this.userEmail,
    required this.userPhone,
    required this.userName,
    this.hiddenMethod,
  });

  Map<String, dynamic> toMap() {
    final options = {
      'key': RazorpayConfig.keyId,
      'amount': (amount * 100).round(),
      'name': RazorpayConfig.companyName,
      'order_id': orderId,
      'description': planName,
      'timeout': RazorpayConfig.timeout,
      'prefill': {'contact': userPhone, 'email': userEmail, 'name': userName},
      'theme': {'color': RazorpayConfig.themeColor},
    };

    if (hiddenMethod != null) {
      final hideMethods = <String>[];
      switch (hiddenMethod!) {
        case PaymentMethod.card:
          hideMethods.addAll(['upi', 'netbanking', 'wallet']);
          break;
        case PaymentMethod.upi:
          hideMethods.addAll(['card', 'netbanking', 'wallet']);
          break;
        case PaymentMethod.netBanking:
          hideMethods.addAll(['card', 'upi', 'wallet']);
          break;
        case PaymentMethod.wallet:
          hideMethods.addAll(['card', 'upi', 'netbanking']);
          break;
      }

      if (hideMethods.isNotEmpty) {
        options['config'] = {
          'display': {'hide': hideMethods},
        };
      }
    }

    return options;
  }
}
