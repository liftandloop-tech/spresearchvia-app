import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user.controller.dart';
import '../../controllers/auth.controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_styles.dart';
import '../notification/notification_settings.screen.dart';
import 'edit_profile.screen.dart';
import 'widgets/KycStatus.Item.dart';
import 'widgets/profile.image.dart';
import 'widgets/profile.tile.dart';
import '../subscription/subscription_history.screen.dart';
import '../../widgets/button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppStyles.appBarTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppTheme.iconRed),
            tooltip: 'Logout',
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        final user = userController.currentUser.value;

        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 80, color: AppTheme.iconGrey),
                SizedBox(height: 16),
                Text('No user data available', style: AppStyles.bodyLarge),
                SizedBox(height: 24),
                Button(
                  title: 'Logout',
                  buttonType: ButtonType.blue,
                  onTap: () => authController.logout(),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              ProfileImageAvatar(
                imagePath:
                    user.profileImage ??
                    'assets/images/profile_placeholder.jpg',
              ),
              SizedBox(height: 20),
              Text(
                user.name,
                style: AppStyles.heading3.copyWith(color: AppTheme.primaryBlue),
              ),
              Text(
                user.email ?? '',
                style: AppStyles.bodySmall.copyWith(color: AppTheme.textGrey),
              ),
              SizedBox(height: 20),
              if (user.contactDetails?.phone != null || user.phone != null)
                ProfileTile(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value: user.contactDetails?.phone?.toString() ?? user.phone!,
                ),
              if (user.contactDetails?.phone != null || user.phone != null)
                SizedBox(height: 10),
              SizedBox(height: 10),
              KycStatusItem(
                icon: Icons.verified_user,
                title: 'KYC Status',
                value:
                    (user.kycStatus?.toString().toLowerCase().contains(
                          'verified',
                        ) ??
                        false)
                    ? 'Verified'
                    : 'Pending',
                statusColor:
                    (user.kycStatus?.toString().toLowerCase().contains(
                          'verified',
                        ) ??
                        false)
                    ? Color(0xff16A34A)
                    : Color(0xffF87171),
                statusLabel:
                    (user.kycStatus?.toString().toLowerCase().contains(
                          'verified',
                        ) ??
                        false)
                    ? 'Completed'
                    : 'Pending',
              ),
              SizedBox(height: 15),
              Button(
                title: 'Edit Profile',
                buttonType: ButtonType.blue,
                icon: Icons.edit_square,
                onTap: () => Get.to(() => EditProfileScreen()),
              ),
              SizedBox(height: 10),
              Button(
                title: 'Subscription History',
                buttonType: ButtonType.blueBorder,
                icon: Icons.history,
                onTap: () => Get.to(() => SubscriptionHistoryScreen()),
              ),
              SizedBox(height: 10),
              Button(
                title: 'Notification Preferences',
                buttonType: ButtonType.greyBorder,
                icon: Icons.notifications,
                onTap: () => Get.to(() => NotificationSettingScreen()),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
