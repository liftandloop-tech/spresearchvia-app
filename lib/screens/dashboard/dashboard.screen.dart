import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../controllers/user.controller.dart';
import '../../controllers/report.controller.dart';
import 'widgets/quick_action_tile.dart';
import '../../widgets/reminder.popup.dart';
import '../../widgets/app_logo.dart';
import 'widgets/premium_plan_card.dart';

class DashboardController extends GetxController {
  final RxBool showReminder = false.obs;
  final RxInt reminderDays = 0.obs;

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

  @override
  void onInit() {
    super.onInit();
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
    Get.toNamed('/quick-renewal');
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final responsive = Responsive.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: responsive.padding(horizontal: AppDimensions.paddingMedium, vertical: AppDimensions.paddingSmall),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: responsive.spacing(AppDimensions.spacing10)),
                    SizedBox(
                      height: responsive.spacing(AppDimensions.logoHeight),
                      width: double.maxFinite,
                      child: AppLogo(),
                    ),
                    SizedBox(height: responsive.spacing(5)),
                    SizedBox(
                      height: responsive.spacing(AppDimensions.containerMedium),
                      child: Row(
                        children: [
                          Expanded(
                            child: GetX<UserController>(
                              builder: (userController) {
                                final userName =
                                    userController.currentUser.value?.name ??
                                    'User';
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppTheme.primaryBlue,
                                        fontSize: responsive.sp(18),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      AppStrings.welcomeBackText,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: responsive.sp(13),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            width: responsive.spacing(AppDimensions.containerSmall),
                            height: responsive.spacing(AppDimensions.containerSmall),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlueDark,
                              borderRadius: BorderRadius.circular(responsive.radius(AppDimensions.radiusLarge)),
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: responsive.spacing(AppDimensions.iconLarge),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: responsive.spacing(AppDimensions.spacing10)),
                    const PremiumPlanCard(),
                    SizedBox(height: responsive.spacing(AppDimensions.spacing10)),
                    Text(
                      AppStrings.quickActions,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: responsive.sp(16),
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(AppDimensions.spacing8)),
                    QuickActionTile(
                      title: AppStrings.subscriptionHistory,
                      icon: Icons.refresh,
                      onTap: () {
                        Get.toNamed('/subscription-history');
                      },
                    ),
                    SizedBox(height: responsive.spacing(AppDimensions.spacing8)),
                    QuickActionTile(
                      title: AppStrings.quickRenewal,
                      icon: Icons.credit_card,
                      onTap: () {
                        Get.toNamed('/quick-renewal');
                      },
                    ),
                    SizedBox(height: responsive.spacing(AppDimensions.spacing20)),
                    Text(
                      AppStrings.thisMonth,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: responsive.sp(16),
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(AppDimensions.spacing10)),
                    Row(
                      children: [
                        Expanded(
                          child: GetX<ReportController>(
                            init: ReportController(),
                            builder: (reportController) {
                              final reportCount =
                                  reportController.reports.length;
                              return Container(
                                height: responsive.spacing(AppDimensions.containerLarge),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: AppDimensions.borderThin,
                                    color: AppTheme.borderGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(responsive.radius(AppDimensions.radiusMedium)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      reportCount.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: responsive.sp(20),
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    ),
                                    Padding(
                                      padding: responsive.padding(horizontal: AppDimensions.spacing8),
                                      child: Text(
                                        AppStrings.reportsAvailable,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                          fontSize: responsive.sp(14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: responsive.spacing(AppDimensions.spacing10)),
                        Expanded(
                          child: Container(
                            height: responsive.spacing(AppDimensions.containerLarge),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: AppDimensions.borderThin,
                                color: AppTheme.borderGrey,
                              ),
                              borderRadius: BorderRadius.circular(responsive.radius(AppDimensions.radiusMedium)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'N/A',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: responsive.sp(20),
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                                Padding(
                                  padding: responsive.padding(horizontal: AppDimensions.spacing8),
                                  child: Text(
                                    AppStrings.researchHours,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: responsive.sp(14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(AppDimensions.spacing20)),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.showReminder.value,
                child: Container(
                  color: const Color.fromARGB(182, 143, 143, 143),
                  child: Obx(
                    () => ReminderPopup(
                      onClose: controller.closeReminder,
                      onRenew: () => controller.renewNow(context),
                      daysRemaining: controller.reminderDays.value,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
