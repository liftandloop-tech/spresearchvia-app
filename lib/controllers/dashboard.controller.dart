import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/routes/app_routes.dart';
import '../controllers/user.controller.dart';

class DashboardController extends GetxController {
  final RxBool showReminder = false.obs;
  final RxInt reminderDays = 0.obs;
  final RxInt researchHours = 0.obs;

  int? _computeDaysRemaining() {
    if (!Get.isRegistered<UserController>()) return null;
    final user = Get.find<UserController>().currentUser.value;
    if (user == null) return null;

    if (user.subscriptionExpiryDate != null) {
      final now = DateTime.now();
      final diff = user.subscriptionExpiryDate!.difference(now);
      return diff.inDays;
    }

    return user.daysRemaining;
  }

  Future<void> fetchResearchHours() async {
    try {
      researchHours.value = 0;
    } catch (e) {
      Get.log('Error fetching research hours: $e');
      researchHours.value = 0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchResearchHours();
    Future.delayed(const Duration(seconds: 1), () {
      final days = _computeDaysRemaining();
      final shouldShow = days != null && days <= 7 && days >= 0;
      showReminder.value = shouldShow;
      reminderDays.value = (days ?? 0).clamp(0, 9999);
    });
  }

  void closeReminder() {
    showReminder.value = false;
  }

  void renewNow(BuildContext context) {
    Get.toNamed(AppRoutes.quickRenewal);
  }
}
