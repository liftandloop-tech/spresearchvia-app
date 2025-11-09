import 'package:get/get.dart';

enum PlanType { annual, oneTime }

class PlanSelectionController extends GetxController {
  final Rx<PlanType> selectedPlan = PlanType.annual.obs;

  final Map<PlanType, Map<String, dynamic>> planDetails = {
    PlanType.annual: {
      'name': 'Annual Plan',
      'amount': 5000,
      'validity': '1 Year Access - Renew Annually',
    },
    PlanType.oneTime: {
      'name': 'One-Time Plan',
      'amount': 10000,
      'validity': 'Lifetime Access – Pay Once',
    },
  };

  final double cgstRate = 0.09;
  final double sgstRate = 0.09;

  void selectPlan(PlanType plan) {
    selectedPlan.value = plan;
  }

  bool isSelected(PlanType plan) {
    return selectedPlan.value == plan;
  }

  int get basePrice {
    return planDetails[selectedPlan.value]!['amount'] as int;
  }

  int get cgstAmount {
    return (basePrice * cgstRate).round();
  }

  int get sgstAmount {
    return (basePrice * sgstRate).round();
  }

  int get totalAmount {
    return basePrice + cgstAmount + sgstAmount;
  }

  String get selectedPlanName {
    return planDetails[selectedPlan.value]!['name'] as String;
  }

  String get selectedPlanValidity {
    return planDetails[selectedPlan.value]!['validity'] as String;
  }

  String get formattedTotal {
    return totalAmount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
