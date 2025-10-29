import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/controllers/auth.controller.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/screens/notification/notification_settings.screen.dart';
import 'package:spresearchvia2/screens/profile/edit_profile.screen.dart';
import 'package:spresearchvia2/screens/profile/widgets/KycStatus.Item.dart';
import 'package:spresearchvia2/screens/profile/widgets/profile.image.dart';
import 'package:spresearchvia2/screens/profile/widgets/profile.tile.dart';
import 'package:spresearchvia2/screens/subscription/subscription_history.screen.dart';
import 'package:spresearchvia2/widgets/button.dart';

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
              ProfileTile(
                icon: Icons.phone,
                title: 'Phone Number',
                value:
                    user.contactDetails?.phone?.toString() ??
                    user.phone ??
                    'N/A',
              ),
              SizedBox(height: 10),
              ProfileTile(
                icon: Icons.credit_card,
                title: 'PAN Number',
                value: 'Not Available',
              ),
              SizedBox(height: 10),
              ProfileTile(
                icon: Icons.fingerprint,
                title: 'Aadhar Number',
                value: 'Not Available',
              ),
              SizedBox(height: 10),
              KycStatusItem(
                icon: Icons.verified_user,
                title: 'KYC Status',
                value: user.kycStatus?.toString().split('.').last ?? 'Pending',
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
