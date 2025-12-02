import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../core/config/api.config.dart';
import '../core/models/research_report.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/snackbar.service.dart';

class ReportController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;
  final reports = <ResearchReport>[].obs;
  final filteredReports = <ResearchReport>[].obs;
  final selectedCategory = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchReportList();
  }

  Future<void> fetchReportList() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get(ApiConfig.reportList);

      if (response.statusCode == 200) {
        final data = response.data;
        final reportList = data['data']?['report'] ?? [];

        if (reportList is List) {
          reports.value = reportList
              .map<ResearchReport>((json) => ResearchReport.fromJson(json))
              .toList();
        }

        applyFilter();
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> downloadReport(String reportId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get(
        ApiConfig.downloadReport(reportId),
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        SnackbarService.showSuccess('Report downloaded successfully');
        return 'downloaded';
      }

      return null;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String? category) {
    selectedCategory.value = category;
    applyFilter();
  }

  void applyFilter() {
    if (selectedCategory.value == null) {
      filteredReports.value = reports;
    } else {
      filteredReports.value = reports
          .where((report) => report.category == selectedCategory.value)
          .toList();
    }
  }

  void clearFilters() {
    selectedCategory.value = null;
    applyFilter();
  }

  List<String> get categories {
    final categorySet = <String>{};
    for (final report in reports) {
      if (report.category.isNotEmpty) {
        categorySet.add(report.category);
      }
    }
    return categorySet.toList()..sort();
  }

  int getReportCountByCategory(String category) {
    return reports.where((report) => report.category == category).length;
  }
}