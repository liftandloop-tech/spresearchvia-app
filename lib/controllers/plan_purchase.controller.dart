import 'package:get/get.dart';
import '../core/config/api.config.dart';
import '../core/models/plan.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/storage.service.dart';
import '../services/snackbar.service.dart';
import '../core/config/app_mode.dart';

class PlanPurchaseController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  final isLoading = false.obs;
  final currentPlan = Rxn<Plan>();
  final expiryRemindersEnabled = true.obs;

  String? get userId => _storage.getUserId();

  @override
  void onInit() {
    super.onInit();
    fetchUserPlan();
  }

  Future<Map<String, dynamic>?> purchasePlan({
    required String packageName,
    required double amount,
  }) async {
    try {
      isLoading.value = true;
      
      if (AppMode.isDevelopment) {
        await Future.delayed(Duration(seconds: 1));
        return {
          'paymentId': 'mock_payment_${DateTime.now().millisecondsSinceEpoch}',
          'razorpayOrderId': 'order_mock_${DateTime.now().millisecondsSinceEpoch}',
          'amount': amount,
          'packageName': packageName,
        };
      } else {
        final uid = userId;
        if (uid == null) {
          SnackbarService.showWarning('User not logged in');
          return null;
        }

        final requestData = {'packageName': packageName, 'amount': amount};

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

          return orderData as Map<String, dynamic>?;
        }

        return null;
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return null;
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
      if (AppMode.isDevelopment) {
        await Future.delayed(Duration(seconds: 1));
        currentPlan.value = Plan(
          id: 'mock_plan_id',
          userId: 'mock_user_id',
          packageName: 'Annual Plan',
          validity: 365,
          startDate: DateTime.now().subtract(Duration(days: 30)),
          endDate: DateTime.now().add(Duration(days: 335)),
          status: 'active',
          name: 'Annual Plan',
          description: 'Full access to all research reports',
          amount: 5900.0,
          validityDays: 365,
          purchaseDate: DateTime.now().subtract(Duration(days: 30)),
          expiryDate: DateTime.now().add(Duration(days: 335)),
          features: ['Premium Reports', 'Market Analysis', 'Expert Support'],
        );
        expiryRemindersEnabled.value = true;
      } else {
        final uid = userId;
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
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      print(error);
    }
  }

  Future<bool> toggleExpiryReminders(bool enabled) async {
    try {
      final uid = userId;
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
        SnackbarService.showSuccess('Expiry reminders ${enabled ? 'enabled' : 'disabled'}');
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
      final uid = userId;
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
      final error = ApiErrorHandler.handleError(e);
      print(error);
      return [];
    }
  }
}