import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

void devSnack(String title, String message, {SnackPosition? snackPosition}) {
  if (kDebugMode) {
    print('SNACKBAR[' + title + ']: ' + message);
  }
  Get.snackbar(title, message, snackPosition: snackPosition);
}
