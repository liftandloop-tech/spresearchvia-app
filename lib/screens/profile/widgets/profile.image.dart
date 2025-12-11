import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileImageAvatar extends StatelessWidget {
  const ProfileImageAvatar({
    super.key,
    required this.imagePath,
    this.size = 120,
    this.isNetworkImage = false,
  });

  final String imagePath;
  final double size;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 3, color: AppTheme.backgroundWhite),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowMedium,
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppTheme.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipOval(child: _buildImage()),
    );
  }

  Widget _buildImage() {
    if (imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
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
            return _buildPlaceholder();
          },
        );
      } catch (e) {
        return _buildPlaceholder();
      }
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.backgroundLightBlue,
      child: Icon(Icons.person, size: size * 0.5, color: AppTheme.primaryBlue),
    );
  }
}
