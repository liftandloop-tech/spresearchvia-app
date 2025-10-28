import 'package:flutter/material.dart';

class PlanRow extends StatelessWidget {
  const PlanRow({super.key, required this.title, required this.value});
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
