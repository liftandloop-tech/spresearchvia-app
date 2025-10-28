import 'package:flutter/material.dart';

class PlanDetailRow extends StatelessWidget {
  const PlanDetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.isExpiry,
  });

  final String label;
  final String value;
  final bool isExpiry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isExpiry ? Color(0xffDC2626) : Color(0xff163174),
          ),
        ),
      ],
    );
  }
}
