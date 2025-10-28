import 'package:flutter/material.dart';

class BenefitItem extends StatelessWidget {
  const BenefitItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check, color: Color(0xff22C55E), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff374151),
            ),
          ),
        ),
      ],
    );
  }
}
