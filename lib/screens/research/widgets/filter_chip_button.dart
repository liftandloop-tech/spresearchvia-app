import 'package:flutter/material.dart';

class FilterChipButton extends StatelessWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Color(0xff2C7F38) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? Color(0xff2C7F38) : Color(0xffE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Color(0xff6B7280),
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Color(0xff1F2937),
              ),
            ),
            if (isActive) ...[
              SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
