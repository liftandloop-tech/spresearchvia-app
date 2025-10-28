import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/models/subscription_history.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;
    IconData? icon;

    switch (status) {
      case SubscriptionStatus.active:
        bgColor = Color(0xffD1FAE5);
        textColor = Color(0xff065F46);
        label = 'Active';
        icon = null;
        break;
      case SubscriptionStatus.expired:
        bgColor = Color(0xffF3F4F6);
        textColor = Color(0xff6B7280);
        label = 'Expired';
        icon = null;
        break;
      case SubscriptionStatus.failed:
        bgColor = Colors.transparent;
        textColor = Color(0xffDC2626);
        label = 'Failed';
        icon = Icons.cancel;
        break;
      case SubscriptionStatus.success:
        bgColor = Colors.transparent;
        textColor = Color(0xff6B7280);
        label = 'Success';
        icon = Icons.check_circle;
        break;
    }

    return Container(
      padding: icon != null
          ? EdgeInsets.symmetric(horizontal: 0, vertical: 0)
          : EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: icon != null ? null : BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: textColor),
            SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
