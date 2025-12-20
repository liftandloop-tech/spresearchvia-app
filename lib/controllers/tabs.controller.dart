import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/dashboard/dashboard.screen.dart';
import '../screens/profile/profile.screen.dart';
import '../screens/research/research_reports.screen.dart';
import '../screens/subscription/choose_plan.screen.dart';

class TabsController extends GetxController {
  final RxInt currentIndex = 0.obs;

  late final List<Widget> screens;

  @override
  void onInit() {
    super.onInit();
    screens = [
      const DashboardScreen(),
      const ResearchReportsScreen(),
      const ChoosePlanScreen(),
      const ProfileScreen(),
    ];
  }

  void changeTab(int index) {
    if (index != currentIndex.value) {
      currentIndex.value = index;
    }
  }
}
