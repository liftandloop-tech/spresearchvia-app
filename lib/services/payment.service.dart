import 'package:get_storage/get_storage.dart';
import 'package:spresearchvia2/core/models/payment.options.dart';

class SavedPaymentMethod {
  final PaymentMethod method;
  final String? cardLast4;
  final String? cardBrand;
  final String? upiId;
  final String? walletName;
  final DateTime savedAt;

  SavedPaymentMethod({
    required this.method,
    this.cardLast4,
    this.cardBrand,
    this.upiId,
    this.walletName,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method.toString(),
      'cardLast4': cardLast4,
      'cardBrand': cardBrand,
      'upiId': upiId,
      'walletName': walletName,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedPaymentMethod.fromJson(Map<String, dynamic> json) {
    return SavedPaymentMethod(
      method: PaymentMethod.values.firstWhere(
        (e) => e.toString() == json['method'],
        orElse: () => PaymentMethod.card,
      ),
      cardLast4: json['cardLast4'],
      cardBrand: json['cardBrand'],
      upiId: json['upiId'],
      walletName: json['walletName'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }

  String get displayText {
    switch (method) {
      case PaymentMethod.card:
        return cardBrand != null && cardLast4 != null
            ? '$cardBrand •••• $cardLast4'
            : 'Credit / Debit Card';
      case PaymentMethod.upi:
        return upiId != null ? upiId! : 'UPI';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      case PaymentMethod.wallet:
        return walletName != null ? walletName! : 'Wallet';
    }
  }
}

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final _storage = GetStorage();
  static const String _savedPaymentKey = 'saved_payment_method';

  Future<void> savePaymentMethod(SavedPaymentMethod paymentMethod) async {
    await _storage.write(_savedPaymentKey, paymentMethod.toJson());
  }

  SavedPaymentMethod? getSavedPaymentMethod() {
    final data = _storage.read(_savedPaymentKey);
    if (data == null) return null;
    try {
      return SavedPaymentMethod.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearSavedPaymentMethod() async {
    await _storage.remove(_savedPaymentKey);
  }

  bool hasSavedPaymentMethod() {
    return _storage.hasData(_savedPaymentKey);
  }
}
