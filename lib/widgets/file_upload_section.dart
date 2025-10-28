import 'package:flutter/material.dart';

class FilePickerContainer extends StatelessWidget {
  const FilePickerContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.fileName,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffE5E7EB),
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffEFF6FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.upload_file_outlined,
              color: Color(0xff11416B),
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff11416B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xff6B7280),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xff11416B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                fileName ?? 'Choose File',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
