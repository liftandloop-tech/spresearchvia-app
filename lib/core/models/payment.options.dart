import 'package:flutter/material.dart';

enum PaymentMethod { card, upi, netBanking, wallet }

class PaymentOption {
  final PaymentMethod method;
  final String title;
  final IconData icon;

  const PaymentOption({
    required this.method,
    required this.title,
    required this.icon,
  });

  static const List<PaymentOption> options = [
    PaymentOption(
      method: PaymentMethod.card,
      title: 'Credit / Debit Card',
      icon: Icons.credit_card,
    ),
    PaymentOption(
      method: PaymentMethod.upi,
      title: 'UPI (Google Pay / Paytm / PhonePe)',
      icon: Icons.phone_android,
    ),
    PaymentOption(
      method: PaymentMethod.netBanking,
      title: 'Net Banking',
      icon: Icons.account_balance,
    ),
    PaymentOption(
      method: PaymentMethod.wallet,
      title: 'Wallet',
      icon: Icons.wallet,
    ),
  ];
}
