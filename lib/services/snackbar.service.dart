import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

abstract class SnackbarService {
  static void showSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    // Print message to console for development visibility.
    // Remove this single print in production if desired.
    // ignore: avoid_print
    print('SNACKBAR: ' + message);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xff374151),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: action,
      ),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showTypedSnackbar(
      context,
      message,
      SnackbarType.success,
      duration: duration,
      action: action,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showTypedSnackbar(
      context,
      message,
      SnackbarType.error,
      duration: duration,
      action: action,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showTypedSnackbar(
      context,
      message,
      SnackbarType.warning,
      duration: duration,
      action: action,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showTypedSnackbar(
      context,
      message,
      SnackbarType.info,
      duration: duration,
      action: action,
    );
  }

  static void _showTypedSnackbar(
    BuildContext context,
    String message,
    SnackbarType type, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();

    final config = _getSnackbarConfig(type);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(config.icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: action,
      ),
    );
  }

  static void showCustom(
    BuildContext context, {
    required String message,
    Color backgroundColor = const Color(0xff374151),
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: "Poppins",
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: action,
      ),
    );
  }

  static void clearAll(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  static _SnackbarConfig _getSnackbarConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(
          color: const Color(0xff2C7F38),
          icon: Icons.check_circle_outline,
        );
      case SnackbarType.error:
        return _SnackbarConfig(
          color: const Color(0xffDC2626),
          icon: Icons.error_outline,
        );
      case SnackbarType.warning:
        return _SnackbarConfig(
          color: const Color(0xffF59E0B),
          icon: Icons.warning_amber_outlined,
        );
      case SnackbarType.info:
        return _SnackbarConfig(
          color: const Color(0xff2563EB),
          icon: Icons.info_outline,
        );
    }
  }
}

class _SnackbarConfig {
  final Color color;
  final IconData icon;

  _SnackbarConfig({required this.color, required this.icon});
}
