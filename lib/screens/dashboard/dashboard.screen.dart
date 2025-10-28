import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/dashboard/widgets/quick_action_tile.dart';
import 'package:spresearchvia2/screens/subscription/quick_renewal.screen.dart';
import 'package:spresearchvia2/screens/subscription/subscription_history.screen.dart';
import 'package:spresearchvia2/widgets/reminder.popup.dart';

import '../../widgets/app_logo.dart';
import 'widgets/premium_plan_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showReminder = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() => showReminder = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      width: double.maxFinite,
                      child: AppLogo(),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sarah Johnson',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xff11416B),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff163174),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    PremiumPlanCard(),
                    SizedBox(height: 20),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff11416B),
                      ),
                    ),
                    SizedBox(height: 10),
                    QuickActionTile(
                      title: 'Subscription History',
                      icon: Icons.refresh,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubscriptionHistoryScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    QuickActionTile(
                      title: 'Auto-Renewal',
                      icon: Icons.person,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuickRenewalScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'This Month',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff11416B),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xffE5E7EB),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '47',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff11416B),
                                  ),
                                ),
                                Text(
                                  'Reports Generated',
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xffE5E7EB),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '23',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff11416B),
                                  ),
                                ),
                                Text(
                                  'Research Hours',
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: showReminder,
              child: Container(
                color: const Color.fromARGB(182, 143, 143, 143),
                child: ReminderPopup(
                  onClose: () => setState(() => showReminder = false),
                  onRenew: () => setState(
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuickRenewalScreen(),
                      ),
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
