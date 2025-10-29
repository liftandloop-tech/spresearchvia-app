import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';

/// Model for Report data
class Report {
  final String id;
  final String title;
  final String description;
  final String? category;
  final String? fileUrl;
  final String? fileName;
  final bool isPublic;
  final DateTime? createdAt;
  final DateTime? publishedAt;

  Report({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.fileUrl,
    this.fileName,
    this.isPublic = false,
    this.createdAt,
    this.publishedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] as String?,
      fileUrl: json['fileUrl'] ?? json['file'] as String?,
      fileName: json['fileName'] as String?,
      isPublic: json['isPublic'] ?? json['public'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'isPublic': isPublic,
      'createdAt': createdAt?.toIso8601String(),
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }
}

/// Controller for Research Reports operations
/// Handles report listing, download, and creation (admin)
class ReportController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  // Observable variables
  final isLoading = false.obs;
  final reports = <Report>[].obs;
  final filteredReports = <Report>[].obs;
  final selectedCategory = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchReportList();
  }

  /// Fetch list of all reports
  Future<void> fetchReportList() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/reports/report-list');

      if (response.statusCode == 200) {
        final data = response.data;
        final reportList = data['data'] ?? data['reports'] ?? [];

        reports.value = (reportList as List)
            .map((json) => Report.fromJson(json))
            .toList();

        // Apply current filter
        applyFilter();
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Download a report by ID
  Future<String?> downloadReport(String reportId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get(
        '/reports/download-report/$reportId',
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        // Return the file bytes or URL from response
        final data = response.data;

        if (data is Map<String, dynamic>) {
          // If response is JSON with download URL
          final downloadUrl = data['url'] ?? data['downloadUrl'];
          if (downloadUrl != null) {
            Get.snackbar(
              'Success',
              'Report ready for download',
              snackPosition: SnackPosition.BOTTOM,
            );
            return downloadUrl;
          }
        }

        // If response is direct file bytes, handle accordingly
        Get.snackbar(
          'Success',
          'Report downloaded successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        return 'downloaded'; // Placeholder for bytes handling
      }

      return null;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new report (admin functionality)
  Future<bool> createReport({
    required String title,
    required String description,
    required File reportFile,
    String? category,
    bool isPublic = false,
  }) async {
    try {
      isLoading.value = true;

      // Create form data
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          reportFile.path,
          filename: reportFile.path.split('/').last,
        ),
        'title': title,
        'description': description,
        if (category != null) 'category': category,
        'isPublic': isPublic,
      });

      final response = await _apiClient.uploadFile(
        '/reports/create-report',
        formData: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Report created successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Refresh report list
        await fetchReportList();

        return true;
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      Get.snackbar('Error', error.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter reports by category
  void filterByCategory(String? category) {
    selectedCategory.value = category;
    applyFilter();
  }

  /// Apply current filter
  void applyFilter() {
    if (selectedCategory.value == null) {
      filteredReports.value = reports;
    } else {
      filteredReports.value = reports
          .where((report) => report.category == selectedCategory.value)
          .toList();
    }
  }

  /// Clear all filters
  void clearFilters() {
    selectedCategory.value = null;
    applyFilter();
  }

  /// Get unique categories from reports
  List<String> get categories {
    final categorySet = <String>{};
    for (final report in reports) {
      if (report.category != null && report.category!.isNotEmpty) {
        categorySet.add(report.category!);
      }
    }
    return categorySet.toList()..sort();
  }

  /// Get reports count by category
  int getReportCountByCategory(String category) {
    return reports.where((report) => report.category == category).length;
  }
}
