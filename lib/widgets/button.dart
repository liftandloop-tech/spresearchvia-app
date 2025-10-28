import 'package:flutter/material.dart';

enum ButtonType { green, blue, blueBorder, greyBorder }

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.title,
    required this.buttonType,
    this.onTap,
    this.icon,
    this.iconRight,
  });

  final String title;
  final ButtonType buttonType;
  final GestureTapCallback? onTap;
  final IconData? icon;
  final IconData? iconRight;

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF11416B);
    const greenColor = Color(0xFF2C7F38);
    const greyBorderColor = Color(0xFFE5E7EB);
    const greyTextColor = Color(0xFF000000);

    Color backgroundColor;
    Color textColor;
    Color iconColor;
    Color? borderColor;

    switch (buttonType) {
      case ButtonType.green:
        backgroundColor = onTap != null ? greenColor : Colors.grey.shade400;
        textColor = Colors.white;
        iconColor = Colors.white;
        borderColor = null;
        break;

      case ButtonType.blue:
        backgroundColor = onTap != null ? blueColor : Colors.grey.shade400;
        textColor = Colors.white;
        iconColor = Colors.white;
        borderColor = null;
        break;

      case ButtonType.blueBorder:
        backgroundColor = Colors.white;
        textColor = blueColor;
        iconColor = blueColor;
        borderColor = blueColor;
        break;

      case ButtonType.greyBorder:
        backgroundColor = Colors.white;
        textColor = greyTextColor;
        iconColor = greyTextColor;
        borderColor = greyBorderColor;
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ).copyWith(color: textColor),
            ),
            if (iconRight != null) ...[
              const SizedBox(width: 8),
              Icon(iconRight, color: iconColor, size: 20),
            ],
            if (onTap == null) ...[
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
