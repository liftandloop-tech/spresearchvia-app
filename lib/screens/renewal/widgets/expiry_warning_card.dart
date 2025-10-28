import 'package:flutter/material.dart';

class ExpiryWarningCard extends StatelessWidget {
  const ExpiryWarningCard({
    super.key,
    required this.daysRemaining,
    required this.message,
  });

  final int daysRemaining;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffFECACA), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning, color: Color(0xffDC2626), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan expiring in $daysRemaining days',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffDC2626),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffDC2626),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
