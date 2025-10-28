import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/notification/widgets/notification_setting_item.dart';
import 'package:spresearchvia2/widgets/button.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingsScrenState();
}

class _NotificationSettingsScrenState extends State<NotificationSettingScreen> {
  bool researchAlert = false;
  bool paymentAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: TextStyle(
            color: Color(0xff11416B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xff163174),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications, color: Colors.white, size: 40),
              ),
              SizedBox(height: 24),

              Text(
                'Stay Informed',
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff163174),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Customize your notifications to stay updated on what\nmatters most to your financial journey.',
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff6B7280),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              NotificationSettingItem(
                value: researchAlert,
                icon: Icons.show_chart_rounded,
                title: 'Research Updates',
                description:
                    'Receive market insights and investment research reports',
                onChanged: (newVal) => setState(() => researchAlert = newVal),
              ),
              SizedBox(height: 5),
              NotificationSettingItem(
                value: paymentAlerts,
                icon: Icons.credit_card,
                title: 'Payment Alerts',
                description:
                    'Instant notifications for all transactions and payments',
                onChanged: (newVal) => setState(() => paymentAlerts = newVal),
              ),
              SizedBox(height: 20),
              Button(
                title: 'Save Preferences',
                buttonType: ButtonType.blue,
                onTap: () => setState(() => Navigator.of(context).pop()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
