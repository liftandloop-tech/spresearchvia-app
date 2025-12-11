import 'package:flutter/material.dart';

class DataProtectionFooter extends StatelessWidget {
  const DataProtectionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: Color(0xff6B7280),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                'Bank-grade security',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xff6B7280),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Row(
            children: [
              Icon(
                Icons.lock_outlined,
                color: Color(0xff6B7280),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '256-bit encryption',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xff6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
