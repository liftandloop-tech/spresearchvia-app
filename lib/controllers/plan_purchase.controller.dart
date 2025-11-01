import 'package:get/get.dart';
import 'package:spresearchvia2/services/api_client.service.dart';
import 'package:spresearchvia2/services/api_exception.service.dart';
import 'package:spresearchvia2/services/storage.service.dart';

class Plan {
  final String id;
  final String name;
  final String description;
  final double amount;
  final int validityDays;
  final List<String> features;
  final bool isActive;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.validityDays,
    required this.features,
    this.isActive = false,
    this.purchaseDate,
    this.expiryDate,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['planName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
      validityDays: json['validityDays'] ?? json['validity'] ?? 0,
      features:
          (json['features'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isActive: json['isActive'] ?? json['active'] ?? false,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.tryParse(json['purchaseDate'].toString())
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'validityDays': validityDays,
      'features': features,
      'isActive': isActive,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}

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
    required String planId,
    required String planName,
    required double amount,
    required int validityDays,
  }) async {
    try {
      final uid = userId;
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in');
        return null;
      }

      isLoading.value = true;

      final response = await _apiClient.post(
        '/user/purchase/plan/$uid',
        data: {
          'planId': planId,
          'planName': planName,
          'amount': amount,
          'validityDays': validityDays,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final orderData = data['data'] ?? data;

        Get.snackbar(
          'Success',
          'Order created successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        return orderData as Map<String, dynamic>?;
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

  Future<bool> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/user/purchase/razorpay/verify',
        data: {
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Payment verified successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        await fetchUserPlan();
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

  Future<void> fetchUserPlan() async {
    try {
      final uid = userId;
      if (uid == null) return;

      final response = await _apiClient.get('/user/purchase/user-plan/$uid');
      if (response.statusCode == 200) {
        final data = response.data;
        final planData = data['data'] ?? data['plan'];

        if (planData != null) {
          currentPlan.value = Plan.fromJson(planData);

          if (planData['expiryRemindersEnabled'] != null) {
            expiryRemindersEnabled.value =
                planData['expiryRemindersEnabled'] == true;
          }
        } else {
          currentPlan.value = null;
        }
      }
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      print('Error fetching user plan: ${error.message}');
    }
  }

  Future<bool> toggleExpiryReminders(bool enabled) async {
    try {
      final uid = userId;
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      isLoading.value = true;

      final response = await _apiClient.patch(
        '/user/purchase/expiry-reminders/$uid',
        data: {'expiryRemindersEnabled': enabled},
      );

      if (response.statusCode == 200) {
        expiryRemindersEnabled.value = enabled;
        Get.snackbar(
          'Success',
          'Expiry reminders ${enabled ? 'enabled' : 'disabled'}',
          snackPosition: SnackPosition.BOTTOM,
        );
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

  bool get hasActivePlan => currentPlan.value?.isActive ?? false;

  int get daysRemaining {
    final expiry = currentPlan.value?.expiryDate;
    if (expiry == null) return 0;
    final now = DateTime.now();
    return expiry.difference(now).inDays;
  }

  bool get isExpiringSoon =>
      hasActivePlan && daysRemaining <= 7 && daysRemaining > 0;

  bool get isPlanExpired => hasActivePlan && daysRemaining <= 0;
}
