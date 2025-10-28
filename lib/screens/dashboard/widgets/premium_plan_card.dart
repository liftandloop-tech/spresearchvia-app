import 'package:flutter/material.dart';

import '../../../widgets/button.dart';

class PremiumPlanCard extends StatelessWidget {
  const PremiumPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff1E4A7C), Color(0xff0D2847)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Premium Plan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xff2C4D6F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '23',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'days left',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Expires on March 15, 2024',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 24),

          Button(
            title: 'Renew Now',
            icon: Icons.refresh,
            onTap: () {},
            buttonType: ButtonType.green,
          ),
        ],
      ),
    );
  }
}
