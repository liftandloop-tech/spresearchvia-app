import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/screens/renewal/widgets/current_badge.dart';
import 'package:spresearchvia2/screens/renewal/widgets/plan_detail_row.dart';

class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({
    super.key,
    required this.planName,
    required this.description,
    required this.price,
    required this.validity,
    required this.expiryDate,
  });

  final String planName;
  final String description;
  final String price;
  final String validity;
  final String expiryDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlueDark, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              CurrentBadge(),
            ],
          ),
          SizedBox(height: 20),
          PlanDetailRow(label: 'Price', value: price, isExpiry: false),
          SizedBox(height: 12),
          PlanDetailRow(label: 'Validity', value: validity, isExpiry: false),
          SizedBox(height: 12),
          PlanDetailRow(label: 'Expires on', value: expiryDate, isExpiry: true),
        ],
      ),
    );
  }
}
