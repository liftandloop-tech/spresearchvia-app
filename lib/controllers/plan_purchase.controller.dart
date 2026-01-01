import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/config/api.config.dart';
import '../core/models/plan.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/secure_storage.service.dart';
import '../services/snackbar.service.dart';

class PlanPurchaseController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

  final isLoading = false.obs;
  final currentPlan = Rxn<Plan>();
  final expiryRemindersEnabled = true.obs;

  Future<String?> get userId => _storage.getUserId();

  @override
  void onInit() {
    super.onInit();
    fetchUserPlan();
  }

  Future<Map<String, dynamic>?> purchasePlan({
    required String packageName,
    required double amount,
    required int validity,
    double cgstAmount = 0,
    double sgstAmount = 0,
  }) async {
    try {
      isLoading.value = true;

      final uid = await userId;
      if (uid == null) {
        throw Exception('User not logged in');
      }

      final requestData = {
        'packageName': packageName,
        'amount': amount,
        'validity': validity,
        'cgstAmount': cgstAmount,
        'sgstAmount': sgstAmount,
      };

      final response = await _apiClient.post(
        ApiConfig.purchasePlan(uid),
        data: requestData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final orderData = data['data'] ?? data;

        final orderCreate = orderData['orderCreate'];
        final userPlan = orderData['userPlan'];

        if (orderCreate != null) {
          return {
            'razorpayOrderId': orderCreate['razorpayOrderId'],
            'paymentId': orderCreate['_id'],
            'orderCreate': orderCreate,
            'userPlan': userPlan,
          };
        }

        if (orderData is Map<String, dynamic>) {
          return orderData;
        }

        throw Exception('Invalid response format from server');
      }

      throw Exception('Server returned status code: ${response.statusCode}');
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyPayment({
    required String paymentId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.verifyPayment,
        data: {
          'paymentId': paymentId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final success = data['success'] ?? false;

        if (success) {
          SnackbarService.showSuccess('Payment verified successfully');
          await fetchUserPlan();
          return true;
        } else {
          SnackbarService.showError(
            data['message'] ?? 'Payment verification failed',
          );
          return false;
        }
      }

      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserPlan() async {
    try {
      final uid = await userId;
      if (uid == null) return;

      final response = await _apiClient.get(ApiConfig.getUserPlan(uid));
      if (response.statusCode == 200) {
        final data = response.data;
        final planData = data['data']?['plan'];

        if (planData != null) {
          currentPlan.value = Plan.fromJson(planData);
          expiryRemindersEnabled.value = planData['expiryReminder'] ?? false;
        } else {
          currentPlan.value = null;
        }
      }
    } catch (e) {
      ApiErrorHandler.handleError(e);
    }
  }

  Future<bool> toggleExpiryReminders(bool enabled) async {
    try {
      final uid = await userId;
      if (uid == null) {
        SnackbarService.showWarning('User not logged in');
        return false;
      }

      isLoading.value = true;
      final response = await _apiClient.patch(
        ApiConfig.toggleExpiryReminders(uid),
        data: {'expiryReminder': enabled},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final reminderStatus = data['data']?['expiryReminderOnOff'];
        expiryRemindersEnabled.value = reminderStatus ?? enabled;
        SnackbarService.showSuccess(
          'Expiry reminders ${enabled ? 'enabled' : 'disabled'}',
        );
        return true;
      }
      return false;
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasActivePlan => currentPlan.value?.isActive ?? false;

  int get daysRemaining {
    final expiry = currentPlan.value?.endDate;
    if (expiry == null) return 0;
    final now = DateTime.now();
    return expiry.difference(now).inDays;
  }

  bool get isExpiringSoon =>
      hasActivePlan && daysRemaining <= 7 && daysRemaining > 0;

  bool get isPlanExpired => hasActivePlan && daysRemaining <= 0;

  Future<List<Plan>> fetchSubscriptionHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final uid = await userId;
      if (uid == null) return [];

      final response = await _apiClient.get(
        ApiConfig.getUserPlan(uid),
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final userPlan = data['data']?['userPlan'] ?? [];

        if (userPlan is List) {
          return userPlan.map<Plan>((json) => Plan.fromJson(json)).toList();
        }
      }

      return [];
    } catch (e) {
      ApiErrorHandler.handleError(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchUserSubscriptionHistoryApi({
    required String userId,
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.userSubscriptionHistory(userId),
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? {};
        return Map<String, dynamic>.from(data as Map);
      }

      return {'totalCount': 0, 'userSubcriptionHistory': []};
    } catch (e) {
      ApiErrorHandler.handleError(e);
      return {'totalCount': 0, 'userSubcriptionHistory': []};
    }
  }

  Future<Map<String, dynamic>> fetchSegmentsListApi({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? category,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.listSegments,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (search != null && search.isNotEmpty) 'search': search,
          if (category != null && category.isNotEmpty) 'category': category,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? {};
        return Map<String, dynamic>.from(data as Map);
      }

      return {'totalCount': 0, 'data': []};
    } catch (e) {
      ApiErrorHandler.handleError(e);
      return {'totalCount': 0, 'data': []};
    }
  }

  Future<Map<String, dynamic>> fetchSegmentPaymentHistoryApi({
    required String userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      debugPrint(
        'DEBUG: fetchSegmentPaymentHistoryApi - userId: $userId, page: $page, pageSize: $pageSize',
      );
      final url = ApiConfig.segmentPaymentHistory(userId);
      debugPrint('DEBUG: API URL: $url');

      final response = await _apiClient.get(
        url,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      debugPrint('DEBUG: Response status: ${response.statusCode}');
      debugPrint('DEBUG: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? {};
        return Map<String, dynamic>.from(data as Map);
      }

      return {'segmentsPaymentCount': 0, 'segmentsPayment': []};
    } catch (e) {
      debugPrint('DEBUG: Error in fetchSegmentPaymentHistoryApi: $e');
      ApiErrorHandler.handleError(e);
      return {'segmentsPaymentCount': 0, 'segmentsPayment': []};
    }
  }
}
