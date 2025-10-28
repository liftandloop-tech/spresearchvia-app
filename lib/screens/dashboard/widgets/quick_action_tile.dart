import 'package:flutter/material.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xff163174),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1F2937),
                ),
              ),
            ),

            Icon(Icons.chevron_right, color: Color(0xffD1D5DB), size: 28),
          ],
        ),
      ),
    );
  }
}
