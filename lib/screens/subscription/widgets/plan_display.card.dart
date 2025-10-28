import 'package:flutter/material.dart';

class PlanDisplayCard extends StatelessWidget {
  const PlanDisplayCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.priceUnit,
    required this.validity,
    this.originalPrice,
    this.badge,
    this.isSelected = false,
    this.isDark = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final String priceUnit;
  final String validity;
  final String? originalPrice;
  final String? badge;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Color(0xff163174) : Colors.white,
          border: Border.all(color: Color(0xffE5E7EB), width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 8,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Color(0xff163174),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : Color(0xff6B7280),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (originalPrice != null) ...[
                      Text(
                        originalPrice!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.5),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                    Text(
                      price,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Color(0xff163174),
                      ),
                    ),
                    Text(
                      priceUnit,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : Color(0xff6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xff2C7F38), size: 18),
                SizedBox(width: 8),
                Text(
                  validity,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Color(0xff163174),
                  ),
                ),
              ],
            ),
            if (badge != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xff1E4A7C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
