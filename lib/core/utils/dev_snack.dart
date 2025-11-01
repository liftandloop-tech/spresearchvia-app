import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Development-only wrapper around Get.snackbar that also logs to console.
void devSnack(String title, String message, {SnackPosition? snackPosition}) {
  if (kDebugMode) {
    // Consistent console logging for all snackbars during development
    // Example: SNACKBAR[Success]: OTP sent successfully to +9199...
    // Keep it single-line for easier grepping in logs.
    // ignore: avoid_print
    print('SNACKBAR[' + title + ']: ' + message);
  }
  Get.snackbar(title, message, snackPosition: snackPosition);
}
