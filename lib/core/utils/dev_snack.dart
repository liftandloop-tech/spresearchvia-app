import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

void devSnack(String title, String message, {SnackPosition? snackPosition}) {
  if (kDebugMode) {}
  Get.snackbar(title, message, snackPosition: snackPosition);
}
