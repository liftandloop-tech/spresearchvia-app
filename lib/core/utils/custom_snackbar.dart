import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/utils/error_message_handler.dart';

/// Custom themed snackbar utility
/// Provides beautiful, consistent snackbar designs matching the app theme
class CustomSnackbar {
  /// Show success snackbar
  static void showSuccess(String message, {String? title, Duration? duration}) {
    Get.snackbar(
      title ?? 'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.success,
      colorText: AppTheme.textWhite,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: AppTheme.success.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      maxWidth: 500,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Show error snackbar
  static void showError(String message, {String? title, Duration? duration}) {
    Get.snackbar(
      title ?? 'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.error,
      colorText: AppTheme.textWhite,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.error_rounded, color: Colors.white, size: 24),
      ),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: duration ?? const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: AppTheme.error.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      maxWidth: 500,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Show error from exception with automatic message cleaning
  static void showErrorFromException(
    dynamic error, {
    String? title,
    String? customMessage,
    Duration? duration,
  }) {
    // Log full error for debugging
    ErrorMessageHandler.logError(title ?? 'Error', error);

    // Get user-friendly message
    final message =
        customMessage ?? ErrorMessageHandler.getUserFriendlyMessage(error);

    showError(message, title: title, duration: duration);
  }

  /// Show warning snackbar
  static void showWarning(String message, {String? title, Duration? duration}) {
    Get.snackbar(
      title ?? 'Warning',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.warning,
      colorText: AppTheme.textWhite,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.warning_rounded, color: Colors.white, size: 24),
      ),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: AppTheme.warning.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      maxWidth: 500,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Show info snackbar
  static void showInfo(String message, {String? title, Duration? duration}) {
    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.primaryBlueDark,
      colorText: AppTheme.textWhite,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.info_rounded, color: Colors.white, size: 24),
      ),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: AppTheme.primaryBlueDark.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      maxWidth: 500,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Show custom styled snackbar
  static void show(
    String message, {
    String? title,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title ?? '',
      message,
      snackPosition: position,
      backgroundColor: backgroundColor ?? AppTheme.primaryBlue,
      colorText: textColor ?? AppTheme.textWhite,
      icon: icon != null
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (textColor ?? Colors.white).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: textColor ?? Colors.white, size: 24),
            )
          : null,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: (backgroundColor ?? AppTheme.primaryBlue).withValues(
            alpha: 0.3,
          ),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      maxWidth: 500,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Show loading snackbar (non-dismissible)
  static void showLoading(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Please Wait',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.primaryBlueDark,
      colorText: AppTheme.textWhite,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: const Duration(days: 1), // Long duration
      isDismissible: false,
      showProgressIndicator: false,
      boxShadows: [
        BoxShadow(
          color: AppTheme.primaryBlueDark.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      maxWidth: 500,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Close all snackbars
  static void closeAll() {
    Get.closeAllSnackbars();
  }

  /// Close current snackbar
  static void close() {
    Get.closeCurrentSnackbar();
  }
}
