import 'package:flutter/material.dart';
import 'category_chip.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.description,
    required this.isDownloaded,
    required this.onTap,
    required this.onDownload,
  });

  final String title;
  final String category;
  final String date;
  final String description;
  final bool isDownloaded;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xffE5E7EB), width: 1),
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
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: onDownload,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDownloaded
                          ? Color(0xffF3F4F6)
                          : Color(0xff2C7F38),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.download,
                      color: isDownloaded ? Color(0xff6B7280) : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                CategoryChip(category: category),
                SizedBox(width: 12),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6B7280),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff4B5563),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
