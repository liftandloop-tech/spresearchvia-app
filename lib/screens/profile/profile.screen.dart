import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/models/user.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xff11416B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            ProfileImageAvatar(
              imagePath: 'assets/images/profile_placeholder.jpg',
            ),
            SizedBox(height: 20),
            Text(
              dummyUser.name,
              style: TextStyle(
                color: Color(0xff11416B),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              dummyUser.email,
              style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20),
            ProfileTile(
              icon: Icons.phone,
              title: 'Phone Number',
              value: dummyUser.phone,
            ),
            SizedBox(height: 10),
            ProfileTile(
              icon: Icons.credit_card,
              title: 'PAN Number',
              value: 'ABCDE1234F',
            ),
            SizedBox(height: 10),
            ProfileTile(
              icon: Icons.fingerprint,
              title: 'Aadhar Number',
              value: 'XXXX XXXX 5678',
            ),
            SizedBox(height: 10),
            KycStatusItem(
              icon: Icons.question_mark_rounded,
              title: 'KYC Status',
              value: 'Verified',
            ),
            SizedBox(height: 15),
            Button(
              title: 'Edit Profile',
              buttonType: ButtonType.blue,
              icon: Icons.edit_square,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            SizedBox(height: 10),
            Button(
              title: 'Subscription History',
              buttonType: ButtonType.blueBorder,
              icon: Icons.history,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SubscriptionHistoryScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Button(
              title: 'Notification Preferences',
              buttonType: ButtonType.greyBorder,
              icon: Icons.notifications,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationSettingScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
