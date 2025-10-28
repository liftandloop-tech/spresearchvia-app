import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final colors = _getCategoryColors(category);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors['text'],
        ),
      ),
    );
  }

  Map<String, Color> _getCategoryColors(String category) {
    switch (category.toLowerCase()) {
      case 'equity':
        return {'bg': Color(0xffDBEAFE), 'text': Color(0xff1E40AF)};
      case 'commodity':
        return {'bg': Color(0xffFEF9C3), 'text': Color(0xff854D0E)};
      default:
        return {'bg': Color(0xffF3F4F6), 'text': Color(0xff374151)};
    }
  }
}
