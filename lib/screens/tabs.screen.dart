import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/screens/dashboard/dashboard.screen.dart';
import 'package:spresearchvia2/screens/profile/profile.screen.dart';
import 'package:spresearchvia2/screens/research/research_reports.screen.dart';
import 'package:spresearchvia2/screens/subscription/choose_plan.screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int currentScreenIndex = 0;
  final List<Widget> screens = [
    DashboardScreen(),
    ResearchReportsScreen(),
    ChoosePlanScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentScreenIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowMedium,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: currentScreenIndex,
              onTap: (index) => setState(() => currentScreenIndex = index),
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
                      isSelected: currentScreenIndex == 0,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: BottomNavbarIcon(
                      iconPath: 'assets/icons/analytics.png',
                      isSelected: currentScreenIndex == 1,
                    ),
                  ),
                  label: 'Research',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: BottomNavbarIcon(
                      iconPath: 'assets/icons/premium.png',
                      isSelected: currentScreenIndex == 2,
                    ),
                  ),
                  label: 'Premium',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: BottomNavbarIcon(
                      iconPath: 'assets/icons/person.png',
                      isSelected: currentScreenIndex == 3,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
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
