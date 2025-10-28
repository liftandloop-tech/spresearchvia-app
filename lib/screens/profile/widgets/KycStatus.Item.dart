import 'package:flutter/material.dart';

class KycStatusItem extends StatelessWidget {
  const KycStatusItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffF0FDF4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xffDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 14, color: Color(0xff16A34A)),
          ),
          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6B7280),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff16A34A),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xffDCFCE7),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              'Completed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff16A34A),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
