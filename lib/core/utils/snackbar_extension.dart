import 'package:get/get.dart';
import 'error_message_handler.dart';

extension GetXSnackbarExtension on GetInterface {
  SnackbarController showErrorSnackbar(
    String title,
    dynamic error, {
    String? customMessage,
    Duration duration = const Duration(seconds: 3),
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    ErrorMessageHandler.logError(title, error);

    final message =
        customMessage ?? ErrorMessageHandler.getUserFriendlyMessage(error);

    return Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      duration: duration,
    );
  }

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
