import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/report.controller.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/trading_call_tab.dart';
import 'widgets/reports_tab.dart';

class ResearchReportsScreen extends StatelessWidget {
  const ResearchReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportController = Get.put(ReportController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Research Reports',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlueDark,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: AppTheme.primaryBlueDark,
              ),
              onPressed: () {
                _showDateBottomSheet(context, reportController);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: AppTheme.backgroundWhite,
              child: TabBar(
                indicatorColor: AppTheme.primaryBlue,
                indicatorWeight: 3,
                labelColor: AppTheme.primaryBlueDark,
                unselectedLabelColor: AppTheme.textGrey,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                onTap: (index) {
                  reportController.selectedTabIndex.value = index;
                },
                tabs: const [
                  Tab(text: 'Trading Call'),
                  Tab(text: 'Reports'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            TradingCallTab(reportController: reportController),
            ReportsTab(reportController: reportController),
          ],
        ),
      ),
    );
  }

  void _showDateBottomSheet(
    BuildContext context,
    ReportController reportController,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date Range',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Today',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              onTap: () {
                final now = DateTime.now();
                reportController.onDateFilterChanged(
                  now.toIso8601String(),
                  now.toIso8601String(),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Last 7 Days',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              onTap: () {
                final now = DateTime.now();
                final start = now.subtract(const Duration(days: 7));
                reportController.onDateFilterChanged(
                  start.toIso8601String(),
                  now.toIso8601String(),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Last 30 Days',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              onTap: () {
                final now = DateTime.now();
                final start = now.subtract(const Duration(days: 30));
                reportController.onDateFilterChanged(
                  start.toIso8601String(),
                  now.toIso8601String(),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.clear, color: AppTheme.primaryBlueDark),
              title: const Text(
                'Clear Filter',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              onTap: () {
                reportController.onDateFilterChanged(null, null);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
