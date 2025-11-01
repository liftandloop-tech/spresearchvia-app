import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/report.controller.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/screens/research/widgets/active_filter_chip.dart';
import 'package:spresearchvia2/screens/research/widgets/filter_chip_button.dart';
import 'package:spresearchvia2/screens/research/widgets/report_card.dart';

class ResearchReportsScreen extends StatelessWidget {
  const ResearchReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportController = Get.find<ReportController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Research Reports', style: AppStyles.appBarTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppTheme.primaryBlue),
            onPressed: () => reportController.fetchReportList(),
          ),
        ],
      ),
      body: Obx(() {
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
            Container(
              color: AppTheme.backgroundWhite,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Obx(
                        () => FilterChipButton(
                          label: 'Category',
                          icon: Icons.category_outlined,
                          isActive:
                              reportController.selectedCategory.value != null,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...reportController.categories.map((
                                      category,
                                    ) {
                                      return ListTile(
                                        title: Text(
                                          category,
                                          style: AppStyles.bodyMedium,
                                        ),
                                        trailing: Text(
                                          '(${reportController.getReportCountByCategory(category)})',
                                          style: AppStyles.caption,
                                        ),
                                        onTap: () {
                                          reportController.filterByCategory(
                                            category,
                                          );
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Obx(() {
                        if (reportController.selectedCategory.value != null) {
                          return GestureDetector(
                            onTap: () => reportController.clearFilters(),
                            child: Text(
                              'Clear',
                              style: AppStyles.link.copyWith(
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
                    ],
                  ),
                  Obx(() {
                    if (reportController.selectedCategory.value != null) {
                      return Column(
                        children: [
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ActiveFilterChip(
                              label: reportController.selectedCategory.value!,
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
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
      }),
    );
  }
}
