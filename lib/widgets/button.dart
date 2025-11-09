import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';

enum ButtonType { green, blue, blueBorder, greyBorder }

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.title,
    required this.buttonType,
    this.onTap,
    this.icon,
    this.iconRight,
    this.showLoading = false,
  });

  final String title;
  final ButtonType buttonType;
  final GestureTapCallback? onTap;
  final IconData? icon;
  final IconData? iconRight;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color iconColor;
    Color? borderColor;

    switch (buttonType) {
      case ButtonType.green:
        backgroundColor = onTap != null
            ? AppTheme.buttonGreen
            : AppTheme.buttonDisabled;
        textColor = AppTheme.textWhite;
        iconColor = AppTheme.textWhite;
        borderColor = null;
        break;

      case ButtonType.blue:
        backgroundColor = onTap != null
            ? AppTheme.buttonBlue
            : AppTheme.buttonDisabled;
        textColor = AppTheme.textWhite;
        iconColor = AppTheme.textWhite;
        borderColor = null;
        break;

      case ButtonType.blueBorder:
        backgroundColor = AppTheme.backgroundWhite;
        textColor = AppTheme.primaryBlue;
        iconColor = AppTheme.primaryBlue;
        borderColor = AppTheme.primaryBlue;
        break;

      case ButtonType.greyBorder:
        backgroundColor = AppTheme.backgroundWhite;
        textColor = AppTheme.textBlack;
        iconColor = AppTheme.textBlack;
        borderColor = AppTheme.borderGrey;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(13),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1.5)
              : null,
          boxShadow: buttonType == ButtonType.greyBorder
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.shadowMedium,
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: AppTheme.shadowMedium,
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(title, style: AppStyles.button.copyWith(color: textColor)),
            if (iconRight != null) ...[
              const SizedBox(width: 8),
              Icon(iconRight, color: iconColor, size: 20),
            ],
            if (showLoading) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
