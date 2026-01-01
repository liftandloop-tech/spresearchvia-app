import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report.controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_styles.dart';
import '../../../services/snackbar.service.dart';
import 'report_card.dart';

class TradingCallTab extends StatelessWidget {
  final ReportController reportController;

  const TradingCallTab({super.key, required this.reportController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reportController.isTradingCallsLoading.value &&
          reportController.tradingCalls.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryBlue),
        );
      }

      if (reportController.tradingCalls.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up, size: 80, color: AppTheme.iconGrey),
              SizedBox(height: 16),
              Text('No trading calls available', style: AppStyles.bodyLarge),
            ],
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!reportController.isTradingCallsLoadingMore.value &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            reportController.loadMoreTradingCalls();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await reportController.fetchTradingCalls(refresh: true);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount:
                reportController.tradingCalls.length +
                (reportController.isTradingCallsLoadingMore.value ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == reportController.tradingCalls.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final report = reportController.tradingCalls[index];
              return ReportCard(
                title: report.title,
                category: report.category,
                date: report.createdAt != null
                    ? '${report.createdAt!.day}/${report.createdAt!.month}/${report.createdAt!.year}'
                    : 'N/A',
                description: report.description,
                onTap: () {
                  SnackbarService.showInfo(
                    'Trading call detail view - Coming soon',
                  );
                },
                onView: () {
                  SnackbarService.showInfo('Trading call view - Coming soon');
                },
              );
            },
          ),
        ),
      );
    });
  }
}
