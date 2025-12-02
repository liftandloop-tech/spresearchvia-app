import 'package:flutter/material.dart';
import 'benefit_item.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key, required this.benefits});

  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What you\'ll continue to get:',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff1F2937),
            ),
          ),
          SizedBox(height: 12),
          ...benefits.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < benefits.length - 1 ? 8 : 0,
              ),
              child: BenefitItem(text: entry.value),
            );
          }).toList(),
        ],
      ),
    );
  }
}
