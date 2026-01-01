import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'profile_placeholder.dart';

class ProfileImageContent extends StatelessWidget {
  final String imagePath;
  final double size;

  const ProfileImageContent({
    super.key,
    required this.imagePath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ProfilePlaceholder(size: size);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: AppTheme.primaryBlue,
            ),
          );
        },
      );
    } else {
      try {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ProfilePlaceholder(size: size);
          },
        );
      } catch (e) {
        return ProfilePlaceholder(size: size);
      }
    }
  }
}
