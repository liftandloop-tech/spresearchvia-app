import 'package:get/get.dart';
import 'package:spresearchvia2/core/utils/error_message_handler.dart';

/// Extension on GetInterface to add user-friendly error snackbars
extension GetXSnackbarExtension on GetInterface {
  /// Show error snackbar with user-friendly message
  /// Automatically cleans up technical error messages
  SnackbarController showErrorSnackbar(
    String title,
    dynamic error, {
    String? customMessage,
    Duration duration = const Duration(seconds: 3),
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    // Log full error for debugging
    ErrorMessageHandler.logError(title, error);

    // Get user-friendly message
    final message =
        customMessage ?? ErrorMessageHandler.getUserFriendlyMessage(error);

    return Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      duration: duration,
    );
  }

  /// Show success snackbar
  SnackbarController showSuccessSnackbar(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    return Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      duration: duration,
    );
  }
}
