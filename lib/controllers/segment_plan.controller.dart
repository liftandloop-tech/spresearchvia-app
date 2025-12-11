import 'package:get/get.dart';
import '../services/snackbar.service.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/secure_storage.service.dart';
import '../core/config/api.config.dart';

class SegmentPlan {
  final String id;
  final String name;
  final String description;
  final String amount;
  final String perDay;
  final List<String> benefits;
  final String? badge;
  final bool isPopular;

  SegmentPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.perDay,
    required this.benefits,
    this.badge,
    this.isPopular = false,
  });

  factory SegmentPlan.fromJson(Map<String, dynamic> json) {
    return SegmentPlan(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['segmentName']?.toString() ?? '',
      description:
          json['description']?.toString() ??
          (json['validity'] != null
              ? 'Validity: ${json['validity']} Days'
              : ''),
      amount: json['amount']?.toString() ?? '',
      perDay:
          json['perDay']?.toString() ??
          (json['daysCharge'] != null
              ? 'Approx ₹${json['daysCharge']}/day'
              : ''),
      benefits:
          (json['benefits'] as List?)?.map((e) => e.toString()).toList() ?? [],
      badge: json['badge']?.toString(),
      isPopular: json['isPopular'] ?? json['popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'perDay': perDay,
      'benefits': benefits,
      'badge': badge,
      'isPopular': isPopular,
    };
  }
}

class SegmentPlanController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

  final isLoading = false.obs;
  final availablePlans = <SegmentPlan>[].obs;
  final selectedPlanId = Rxn<String>();
  final error = Rxn<String>();

  Future<String?> get userId => _storage.getUserId();

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiClient.get(ApiConfig.listSegments);

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> plansData = data['data']['data'] ?? [];
        availablePlans.value = plansData
            .map((json) => SegmentPlan.fromJson(json))
            .toList();

        if (selectedPlanId.value == null) {
          final popularPlan = availablePlans.firstWhereOrNull(
            (p) => p.isPopular,
          );
          if (popularPlan != null) {
            selectedPlanId.value = popularPlan.id;
          }
        }
      } else {
        throw Exception('Failed to load plans');
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      error.value = e.toString();
      SnackbarService.showError('Failed to load plans: ${e.toString()}');
    }
  }

  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }

  SegmentPlan? get selectedPlan {
    if (selectedPlanId.value == null) return null;
    return availablePlans.firstWhereOrNull(
      (plan) => plan.id == selectedPlanId.value,
    );
  }

  bool isPlanSelected(String planId) {
    return selectedPlanId.value == planId;
  }

  Future<void> retry() async {
    await fetchPlans();
  }

  Future<Map<String, dynamic>?> purchaseSegment({
    required String segmentId,
  }) async {
    try {
      isLoading.value = true;

      final uid = await userId;
      if (uid == null) {
        throw Exception('User not logged in');
      }

      final response = await _apiClient.post(
        ApiConfig.segmentPurchase,
        data: {'userId': uid, 'segmentId': segmentId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['data'] ?? data;
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

  Future<bool> verifySegmentPayment({
    required String segmentId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.segmentPaymentVerify,
        data: {
          'segmentId': segmentId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final success = data['success'] ?? false;

        if (success) {
          SnackbarService.showSuccess('Payment verified successfully!');
          return true;
        }
      }

      throw Exception('Payment verification failed');
    } catch (e) {
      final error = ApiErrorHandler.handleError(e);
      SnackbarService.showError(error.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
