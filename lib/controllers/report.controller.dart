import 'package:get/get.dart';
import '../core/config/api.config.dart';
import '../core/models/research_report.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/snackbar.service.dart';
import '../services/secure_storage.service.dart';

class ReportController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Reports State
  final isReportsLoading = false.obs;
  final isReportsLoadingMore = false.obs;
  final reports = <ResearchReport>[].obs;
  final reportsPage = 1.obs;
  final reportsHasMore = true.obs;

  // Trading Calls State
  final isTradingCallsLoading = false.obs;
  final isTradingCallsLoadingMore = false.obs;
  final tradingCalls = <ResearchReport>[].obs;
  final tradingCallsPage = 1.obs;
  final tradingCallsHasMore = true.obs;

  final selectedTabIndex = 0.obs;

  // Filters
  final searchQuery = ''.obs;
  final startDate = RxnString();
  final endDate = RxnString();

  static const int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchReportList();
    fetchTradingCalls();
  }

  // --- Research Reports Logic ---

  Future<void> fetchReportList({bool refresh = false}) async {
    if (refresh) {
      reportsPage.value = 1;
      reportsHasMore.value = true;
      reports.clear();
    }

    if (!reportsHasMore.value && !refresh) return;

    try {
      if (reportsPage.value == 1) {
        isReportsLoading.value = true;
      } else {
        isReportsLoadingMore.value = true;
      }

      final response = await _apiClient.get(
        ApiConfig.reportList(
          page: reportsPage.value,
          pageSize: _pageSize,
          search: searchQuery.value,
          startDate: startDate.value,
          endDate: endDate.value,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final reportList = data['data']?['report'] ?? [];

        if (reportList is List) {
          final newReports = reportList
              .map<ResearchReport>((json) => ResearchReport.fromJson(json))
              .toList();

          if (newReports.length < _pageSize) {
            reportsHasMore.value = false;
          }

          if (refresh) {
            reports.assignAll(newReports);
          } else {
            reports.addAll(newReports);
          }

          if (newReports.isNotEmpty) {
            reportsPage.value++;
          }
        }
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
    } finally {
      isReportsLoading.value = false;
      isReportsLoadingMore.value = false;
    }
  }

  Future<void> loadMoreReports() async {
    if (!isReportsLoading.value &&
        !isReportsLoadingMore.value &&
        reportsHasMore.value) {
      await fetchReportList();
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchReportList(refresh: true);
  }

  void onDateFilterChanged(String? start, String? end) {
    startDate.value = start;
    endDate.value = end;
    fetchReportList(refresh: true);
    fetchTradingCalls(refresh: true);
  }

  // --- Trading Calls Logic ---

  Future<void> fetchTradingCalls({bool refresh = false}) async {
    if (refresh) {
      tradingCallsPage.value = 1;
      tradingCallsHasMore.value = true;
      tradingCalls.clear();
    }

    if (!tradingCallsHasMore.value && !refresh) return;

    try {
      final userId = await _secureStorage.getUserId();
      if (userId == null) return;

      if (tradingCallsPage.value == 1) {
        isTradingCallsLoading.value = true;
      } else {
        isTradingCallsLoadingMore.value = true;
      }

      final response = await _apiClient.get(
        ApiConfig.userReportList(
          userId,
          page: tradingCallsPage.value,
          pageSize: _pageSize,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final reportList = data['data']?['report'] ?? [];

        if (reportList is List) {
          final newReports = reportList
              .map<ResearchReport>((json) => ResearchReport.fromJson(json))
              .toList();

          if (newReports.length < _pageSize) {
            tradingCallsHasMore.value = false;
          }

          if (refresh) {
            tradingCalls.assignAll(newReports);
          } else {
            tradingCalls.addAll(newReports);
          }

          if (newReports.isNotEmpty) {
            tradingCallsPage.value++;
          }
        }
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
    } finally {
      isTradingCallsLoading.value = false;
      isTradingCallsLoadingMore.value = false;
    }
  }

  Future<void> loadMoreTradingCalls() async {
    if (!isTradingCallsLoading.value &&
        !isTradingCallsLoadingMore.value &&
        tradingCallsHasMore.value) {
      await fetchTradingCalls();
    }
  }
}
