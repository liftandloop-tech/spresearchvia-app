import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

enum PaymentMethodType {
  visa,
  mastercard,
  rupay,
  amex,
  upi,
  netbanking,
  unknown,
}

class PaymentMethodData {
  final PaymentMethodType type;
  final String lastFourDigits;
  final String? expiryDate;
  final String? upiId;
  final String? bankName;
  final bool isSelected;

  PaymentMethodData({
    required this.type,
    this.lastFourDigits = '',
    this.expiryDate,
    this.upiId,
    this.bankName,
    this.isSelected = false,
  });

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) {
    return PaymentMethodData(
      type: _parsePaymentType(json['type']?.toString() ?? ''),
      lastFourDigits: json['lastFourDigits']?.toString() ?? '',
      expiryDate: json['expiryDate']?.toString(),
      upiId: json['upiId']?.toString(),
      bankName: json['bankName']?.toString(),
      isSelected: json['isSelected'] ?? false,
    );
  }

  static PaymentMethodType _parsePaymentType(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return PaymentMethodType.visa;
      case 'mastercard':
      case 'master':
        return PaymentMethodType.mastercard;
      case 'rupay':
        return PaymentMethodType.rupay;
      case 'amex':
      case 'american express':
        return PaymentMethodType.amex;
      case 'upi':
        return PaymentMethodType.upi;
      case 'netbanking':
      case 'net banking':
        return PaymentMethodType.netbanking;
      default:
        return PaymentMethodType.unknown;
    }
  }

  String get displayName {
    switch (type) {
      case PaymentMethodType.visa:
        return 'VISA';
      case PaymentMethodType.mastercard:
        return 'MASTERCARD';
      case PaymentMethodType.rupay:
        return 'RuPay';
      case PaymentMethodType.amex:
        return 'AMEX';
      case PaymentMethodType.upi:
        return 'UPI';
      case PaymentMethodType.netbanking:
        return 'Net Banking';
      case PaymentMethodType.unknown:
        return 'Card';
    }
  }

  Color get brandColor {
    switch (type) {
      case PaymentMethodType.visa:
        return const Color(0xFF1A1F71);
      case PaymentMethodType.mastercard:
        return const Color(0xFFEB001B);
      case PaymentMethodType.rupay:
        return const Color(0xFF097939);
      case PaymentMethodType.amex:
        return const Color(0xFF006FCF);
      case PaymentMethodType.upi:
        return const Color(0xFF6C3FB5);
      case PaymentMethodType.netbanking:
        return const Color(0xFF0066CC);
      case PaymentMethodType.unknown:
        return AppTheme.primaryBlue;
    }
  }
}

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    this.onTap,
    this.showCheckmark = true,
  });

  final PaymentMethodData paymentMethod;
  final VoidCallback? onTap;
  final bool showCheckmark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: paymentMethod.isSelected
                ? const Color(0xFF10B981)
                : const Color(0xFFE2E8F0),
            width: paymentMethod.isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _buildPaymentIcon(),
            const SizedBox(width: 12),
            Expanded(child: _buildPaymentDetails()),
            if (showCheckmark && paymentMethod.isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF10B981),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon() {
    if (paymentMethod.type == PaymentMethodType.upi) {
      return Container(
        width: 48,
        height: 32,
        decoration: BoxDecoration(
          color: paymentMethod.brandColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    }

    if (paymentMethod.type == PaymentMethodType.netbanking) {
      return Container(
        width: 48,
        height: 32,
        decoration: BoxDecoration(
          color: paymentMethod.brandColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Icon(Icons.account_balance, color: Colors.white, size: 20),
        ),
      );
    }

    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        color: paymentMethod.brandColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          paymentMethod.displayName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: paymentMethod.type == PaymentMethodType.mastercard
                ? 8
                : 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    if (paymentMethod.type == PaymentMethodType.upi) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            paymentMethod.upiId ?? 'UPI ID',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlueDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'UPI Payment',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      );
    }

    if (paymentMethod.type == PaymentMethodType.netbanking) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            paymentMethod.bankName ?? 'Bank Account',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlueDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Net Banking',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      );
    }

    // Card payment details
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '**** **** **** ${paymentMethod.lastFourDigits.padLeft(4, '0')}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
        if (paymentMethod.expiryDate != null) ...[
          const SizedBox(height: 2),
          Text(
            'Expires ${paymentMethod.expiryDate}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ],
    );
  }
}
