import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class SummaryItem extends StatelessWidget {
  final String title;
  final int amount;
  final bool isBold;

  const SummaryItem({
    super.key,
    required this.title,
    required this.amount,
    this.isBold = false,
  });

  String get formattedAmount {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: isBold ? 20 : 16,
      fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
      color: isBold ? AppTheme.primaryBlue : Colors.black87,
    );

    final amountStyle = TextStyle(
      fontSize: isBold ? 20 : 16,
      fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
      color: isBold ? AppTheme.primaryGreen : Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: textStyle)),
          const SizedBox(width: 10),
          Text('₹$formattedAmount', style: amountStyle),
        ],
      ),
    );
  }
}

class PaymentSummaryCard extends StatelessWidget {
  final int basePrice;
  final int cgstAmount;
  final int sgstAmount;
  final int totalAmount;
  final BoxDecoration? decoration;

  const PaymentSummaryCard({
    super.key,
    required this.basePrice,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.totalAmount,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final containerDecoration =
        decoration ??
        BoxDecoration(
          border: Border.all(color: AppTheme.borderGrey),
          borderRadius: BorderRadius.circular(12),
        );

    return Container(
      decoration: containerDecoration,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SummaryItem(title: 'Base Price', amount: basePrice),
          SummaryItem(title: 'CGST (9%)', amount: cgstAmount),
          SummaryItem(title: 'SGST (9%)', amount: sgstAmount),
          const SizedBox(height: 10),
          const Divider(color: AppTheme.textGrey),
          const SizedBox(height: 5),
          SummaryItem(
            title: 'Total Payable',
            amount: totalAmount,
            isBold: true,
          ),
        ],
      ),
    );
  }
}
