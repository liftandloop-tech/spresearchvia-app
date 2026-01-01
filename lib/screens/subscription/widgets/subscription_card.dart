import 'package:flutter/material.dart';
import '../../../core/models/subscription_history.dart';
import 'status_badge.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.paymentDate,
    required this.amountPaid,
    required this.validityDays,
    required this.expiryDate,
    required this.headerStatus,
    required this.footerStatus,
    this.onTap,
  });

  final String paymentDate;
  final String amountPaid;
  final String validityDays;
  final String expiryDate;
  final SubscriptionStatus headerStatus;
  final SubscriptionStatus footerStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String formatDate(String value) {
      try {
        if (value.trim().isEmpty) return '-';

        // Try to parse as ISO date
        final dt = DateTime.tryParse(value);
        if (dt != null) {
          final localDt = dt.toLocal();
          const months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          final dd = localDt.day.toString().padLeft(2, '0');
          final mon = months[localDt.month - 1];
          final yyyy = localDt.year.toString();
          return '$dd $mon $yyyy';
        }

        // If not ISO, return as-is (already formatted like "Jan 1, 2025")
        return value;
      } catch (_) {
        return value;
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(paymentDate),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff163174),
                      ),
                    ),
                  ],
                ),
                StatusBadge(status: headerStatus),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Amount Paid',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        amountPaid,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff163174),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Validity Days',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        validityDays,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff163174),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expiry Date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(expiryDate),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff163174),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
