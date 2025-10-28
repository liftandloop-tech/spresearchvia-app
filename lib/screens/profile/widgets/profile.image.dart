import 'package:flutter/material.dart';

class ProfileImageAvatar extends StatelessWidget {
  const ProfileImageAvatar({
    super.key,
    required this.imagePath,
    this.size = 120,
  });

  final String imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 3, color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 10),
            blurRadius: 15,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}
