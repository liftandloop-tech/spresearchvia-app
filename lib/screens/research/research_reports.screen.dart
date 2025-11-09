import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/report.controller.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/screens/research/widgets/active_filter_chip.dart';
import 'package:spresearchvia2/screens/research/widgets/filter_chip_button.dart';
import 'package:spresearchvia2/screens/research/widgets/report_card.dart';

class ResearchReportsScreen extends StatefulWidget {
  const ResearchReportsScreen({super.key});

  @override
  State<ResearchReportsScreen> createState() => _ResearchReportsScreenState();
}

class _ResearchReportsScreenState extends State<ResearchReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportController = Get.find<ReportController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBlueDark),
          onPressed: () => Get.back(),
        ),
        title: Text(
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
            icon: Icon(Icons.search, color: AppTheme.primaryBlueDark),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: AppTheme.backgroundWhite,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryBlue,
              indicatorWeight: 3,
              labelColor: AppTheme.primaryBlueDark,
              unselectedLabelColor: AppTheme.textGrey,
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: 'Trading Call'),
                Tab(text: 'Reports'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Trading Call Tab
          _buildTradingCallTab(reportController),
          // Reports Tab
          _buildReportsTab(reportController),
        ],
      ),
    );
  }

  Widget _buildTradingCallTab(ReportController reportController) {
    return Center(
      child: Text(
        'Trading Call - Coming Soon',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: AppTheme.textGrey,
        ),
      ),
    );
  }

  Widget _buildReportsTab(ReportController reportController) {
    return Obx(() {
      if (reportController.isLoading.value &&
          reportController.reports.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppTheme.primaryBlue),
        );
      }

      if (reportController.reports.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description_outlined,
                size: 80,
                color: AppTheme.iconGrey,
              ),
              SizedBox(height: 16),
              Text('No reports available', style: AppStyles.bodyLarge),
            ],
          ),
        );
      }

      return Column(
        children: [
          // Filters Section
          Container(
            color: AppTheme.backgroundWhite,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Filter Buttons Row
                Row(
                  children: [
                    Obx(
                      () => FilterChipButton(
                        label: 'Category',
                        icon: Icons.expand_more,
                        isActive:
                            reportController.selectedCategory.value != null,
                        onTap: () {
                          _showCategoryBottomSheet(context, reportController);
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    FilterChipButton(
                      label: 'Date',
                      icon: Icons.expand_more,
                      isActive: false,
                      onTap: () {
                        _showDateBottomSheet(context, reportController);
                      },
                    ),
                    SizedBox(width: 12),
                    Obx(() {
                      if (reportController.selectedCategory.value != null) {
                        return GestureDetector(
                          onTap: () => reportController.clearFilters(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppTheme.textGrey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                  ],
                ),
                // Active Filters
                Obx(() {
                  if (reportController.selectedCategory.value != null) {
                    return Column(
                      children: [
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Active:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textGrey,
                              ),
                            ),
                            SizedBox(width: 8),
                            ActiveFilterChip(
                              label: reportController.selectedCategory.value!,
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
          // Reports List
          Expanded(
            child: Obx(() {
              final reports = reportController.filteredReports;

              if (reports.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_alt_off,
                        size: 80,
                        color: AppTheme.iconGrey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No reports match your filters',
                        style: AppStyles.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: reports.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return ReportCard(
                    title: report.title,
                    category: report.category ?? 'Uncategorized',
                    date: report.createdAt != null
                        ? '${report.createdAt!.day}/${report.createdAt!.month}/${report.createdAt!.year}'
                        : 'N/A',
                    description: report.description,
                    isDownloaded: false,
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Report detail view - Coming soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    onDownload: () async {
                      final result = await reportController.downloadReport(
                        report.id,
                      );
                      if (result != null) {}
                    },
                  );
                },
              );
            }),
          ),
        ],
      );
    });
  }

  void _showCategoryBottomSheet(
    BuildContext context,
    ReportController reportController,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            SizedBox(height: 16),
            ...reportController.categories.map((category) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  category,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
                trailing: Text(
                  '(${reportController.getReportCountByCategory(category)})',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
                onTap: () {
                  reportController.filterByCategory(category);
                  Navigator.pop(context);
                },
              );
            }).toList(),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date Range',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Today',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement date filter
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Last 7 Days',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement date filter
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Last 30 Days',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement date filter
              },
            ),
          ],
        ),
      ),
    );
  }
}
