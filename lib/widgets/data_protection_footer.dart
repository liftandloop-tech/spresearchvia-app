import 'package:flutter/material.dart';

class DataProtectionFooter extends StatelessWidget {
  const DataProtectionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: Color(0xff6B7280),
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                'Bank-grade security',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xff6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Icon(
                Icons.lock_outlined,
                color: Color(0xff6B7280),
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text(
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
