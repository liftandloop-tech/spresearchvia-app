import 'package:get/get.dart';
import '../services/snackbar.service.dart';

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
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      perDay: json['perDay']?.toString() ?? '',
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
  final isLoading = false.obs;
  final availablePlans = <SegmentPlan>[].obs;
  final selectedPlanId = Rxn<String>();
  final error = Rxn<String>();

  final Duration _networkDelay = const Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      error.value = null;

      await Future.delayed(_networkDelay);

      final mockPlans = _generateMockPlans();

      availablePlans.value = mockPlans;

      final popularPlan = mockPlans.firstWhereOrNull((p) => p.isPopular);
      if (popularPlan != null) {
        selectedPlanId.value = popularPlan.id;
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

  List<SegmentPlan> _generateMockPlans() {
    return [
      SegmentPlan(
        id: 'plan_splendid_001',
        name: 'Splendid',
        description: 'Advanced insights for serious traders.',
        amount: '₹1.51 Lakh/year',
        perDay: 'Approx ₹415/day',
        benefits: [
          'Daily in-depth research calls',
          'Dedicated analyst support',
          'Weekly performance reports',
          'Access to premium webinars',
        ],
        isPopular: false,
      ),
      SegmentPlan(
        id: 'plan_spark_001',
        name: 'Spark',
        description: 'Essential signals for smart decisions.',
        amount: '₹99,000',
        perDay: 'Approx ₹270/day',
        benefits: [
          'Daily basic calls & market alerts',
          'Limited analyst access',
          'Performance summary emails',
        ],
        isPopular: true,
      ),
      SegmentPlan(
        id: 'plan_hni_001',
        name: 'HNI Custom Plan',
        description:
            'Exclusive personalized research service created by SP ResearchVia',
        amount: '₹2,50,000',
        perDay: 'Valid for 1 Year\nApprox ₹685/day',
        benefits: [
          'Tailored investment and trading research',
          'Direct analyst consultation',
          'Priority updates and private market insights',
          'Multi-segment strategy coverage',
          'Custom reporting and performance tracking',
        ],
        isPopular: false,
      ),
    ];
  }
}
