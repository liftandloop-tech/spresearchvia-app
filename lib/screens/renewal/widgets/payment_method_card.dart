import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/renewal/widgets/card_type_logo.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.cardType,
    required this.cardNumber,
    required this.expiryDate,
  });

  final String cardType;
  final String cardNumber;
  final String expiryDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          CardTypeLogo(cardType: cardType),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardNumber,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1F2937),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  expiryDate,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Color(0xff10B981), size: 24),
        ],
      ),
    );
  }
}
