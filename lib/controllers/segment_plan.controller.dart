import 'package:get/get.dart';
import '../services/snackbar.service.dart';
import '../services/api_client.service.dart';
import '../services/api_exception.service.dart';
import '../services/secure_storage.service.dart';
import '../core/config/api.config.dart';

class SegmentPlan {
  final String id;
  final String category;
  final String name;
  final String description;
  final String amount;
  final String perDay;
  final List<String> benefits;
  final String? badge;
  final bool isPopular;

  SegmentPlan({
    required this.id,
    required this.category,
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
      category: json['category']?.toString() ?? '',
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
              ? 'Starts from ₹${json['daysCharge']}/day'
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
      'category': category,
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
  Future<Map<String, dynamic>?> purchaseSegment({
    required String segmentId,
  }) async {
    try {
      isLoading.value = true;
      final uid = await userId;
      if (uid == null) throw Exception('User not logged in');
      final response = await _apiClient.post(
        ApiConfig.segmentPurchase,
        data: {'userId': uid, 'segmentId': segmentId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
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

  final ApiClient _apiClient = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

  final isLoading = false.obs;
  final availablePlans = <SegmentPlan>[].obs;
  final selectedPlanId = Rxn<String>();
  final error = Rxn<String>();
  final selectedSegment = 'SPARK'.obs;

  Future<String?> get userId => _storage.getUserId();

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans({String? category}) async {
    try {
      isLoading.value = true;
      error.value = null;

      final categoryFilter = category ?? selectedSegment.value;
      final url = '${ApiConfig.listSegments}?category=$categoryFilter';
      final response = await _apiClient.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> plansData = data['data']['data'] ?? [];
        availablePlans.value = plansData
            .map((json) => SegmentPlan.fromJson(json))
            .toList();

        // Auto-select a popular plan if none selected
        if (selectedPlanId.value == null && availablePlans.isNotEmpty) {
          final popularPlan = availablePlans.firstWhereOrNull(
            (p) => p.isPopular,
          );
          selectedPlanId.value = popularPlan?.id ?? availablePlans.first.id;
        }
      } else {
        throw Exception('Failed to load plans');
      }
    } catch (e) {
      error.value = e.toString();
      SnackbarService.showError('Failed to load plans: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }

  SegmentPlan? get selectedPlan => availablePlans.firstWhereOrNull(
    (plan) => plan.id == selectedPlanId.value,
  );

  bool isPlanSelected(String planId) => selectedPlanId.value == planId;

  Future<void> retry() async => fetchPlans();

  void filterBySegment(String segment) {
    selectedSegment.value = segment;
    fetchPlans(category: segment);
  }
}
