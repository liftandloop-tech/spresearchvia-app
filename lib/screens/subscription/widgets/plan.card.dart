import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.planName,
    required this.amount,
    required this.validity,
    required this.selected,
    this.popular = false,
    required this.onTap,
  });
  final String planName, validity;
  final int amount;
  final bool popular, selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? AppTheme.backgroundLightBlue : Colors.white,
          border: Border.all(
            width: 2,
            color: selected ? AppTheme.primaryBlue : AppTheme.borderGrey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    planName,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlueDark,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppTheme.primaryBlue : Colors.white,
                    border: Border.all(
                      color: selected
                          ? AppTheme.primaryBlue
                          : AppTheme.borderGrey,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
                SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      Text(
                        '(Excluding GST)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: AppTheme.textGrey,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppTheme.textGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              validity,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
