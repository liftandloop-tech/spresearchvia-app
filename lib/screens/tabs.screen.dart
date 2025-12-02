import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_styles.dart';
import '../controllers/report.controller.dart';
import '../controllers/plan_purchase.controller.dart';
import 'dashboard/dashboard.screen.dart';
import 'profile/profile.screen.dart';
import 'research/research_reports.screen.dart';
import 'subscription/choose_plan.screen.dart';

class TabsController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // Cache screens to avoid rebuilding
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

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabsController());
    
    // Initialize required controllers
    Get.put(ReportController());
    Get.put(PlanPurchaseController());

    // Set initial index from Get.arguments
    final int initialIndex = Get.arguments ?? 0;
    controller.currentIndex.value = initialIndex;

    return Obx(
      () => Scaffold(
        body: controller.screens[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowMedium,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: controller.changeTab,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppTheme.backgroundWhite,
                selectedItemColor: AppTheme.primaryGreen,
                unselectedItemColor: AppTheme.iconGrey,
                selectedLabelStyle: AppStyles.tabLabel,
                unselectedLabelStyle: AppStyles.tabLabelInactive,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                enableFeedback: false,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: BottomNavbarIcon(
                        iconPath: 'assets/icons/home.png',
                        isSelected: controller.currentIndex.value == 0,
                      ),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: BottomNavbarIcon(
                        iconPath: 'assets/icons/analytics.png',
                        isSelected: controller.currentIndex.value == 1,
                      ),
                    ),
                    label: 'Research',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: BottomNavbarIcon(
                        iconPath: 'assets/icons/premium.png',
                        isSelected: controller.currentIndex.value == 2,
                      ),
                    ),
                    label: 'Premium',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: BottomNavbarIcon(
                        iconPath: 'assets/icons/person.png',
                        isSelected: controller.currentIndex.value == 3,
                      ),
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavbarIcon extends StatelessWidget {
  const BottomNavbarIcon({
    super.key,
    required this.iconPath,
    required this.isSelected,
  });

  final String iconPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isSelected ? AppTheme.primaryGreen : AppTheme.iconGrey,
        BlendMode.srcIn,
      ),
      child: Image.asset(iconPath, width: 24, height: 24),
    );
  }
}
