import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../core/models/subscription_history.dart';
import 'widgets/subscription_card.dart';
import '../../services/snackbar.service.dart';

class SubscriptionHistoryController extends GetxController {
  final planController = Get.put(PlanPurchaseController());

  final RxString selectedFilter = 'Latest'.obs;
  final RxList<SubscriptionHistory> subscriptions = <SubscriptionHistory>[].obs;
  final RxList<SubscriptionHistory> _allSubscriptions =
      <SubscriptionHistory>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubscriptionHistory();

    ever(selectedFilter, (_) => _applyFilter());
  }

  Future<void> loadSubscriptionHistory() async {
    isLoading.value = true;

    try {
      final plans = await planController.fetchSubscriptionHistory();
      final loadedSubscriptions = plans
          .map(
            (plan) => SubscriptionHistory(
              id: plan.id,
              paymentDate: plan.startDate.toString().split(' ')[0],
              amountPaid: '₹${(plan.validity * 10).toString()}',
              validityDays: '${plan.validity} days',
              expiryDate: plan.endDate.toString().split(' ')[0],
              headerStatus: plan.isActive
                  ? SubscriptionStatus.active
                  : plan.isExpired
                  ? SubscriptionStatus.expired
                  : SubscriptionStatus.pending,
              footerStatus: plan.isFailed
                  ? SubscriptionStatus.failed
                  : SubscriptionStatus.success,
            ),
          )
          .toList();

      _allSubscriptions.value = loadedSubscriptions;
      _applyFilter();
    } catch (e) {
      SnackbarService.showError('Failed to load subscription history');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    subscriptions.value = _filterSubscriptions(_allSubscriptions);
  }

  List<SubscriptionHistory> _filterSubscriptions(
    List<SubscriptionHistory> subs,
  ) {
    List<SubscriptionHistory> filtered = List.from(subs);

    switch (selectedFilter.value) {
      case 'Latest':
        break;
      case 'Oldest':
        filtered = filtered.reversed.toList();
        break;
      case 'Active':
        filtered = filtered
            .where((s) => s.headerStatus == SubscriptionStatus.active)
            .toList();
        break;
      case 'Expired':
        filtered = filtered
            .where((s) => s.headerStatus == SubscriptionStatus.expired)
            .toList();
        break;
    }

    return filtered;
  }

  void changeFilter(String? newFilter) {
    if (newFilter != null) {
      selectedFilter.value = newFilter;
    }
  }
}

class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

  void _showReceiptDialog(
    BuildContext context,
    SubscriptionHistory subscription,
  ) {
    Get.toNamed('/receipt');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionHistoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff163174)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription History',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff163174),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffE5E7EB), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => DropdownButton<String>(
                value: controller.selectedFilter.value,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xff6B7280),
                  size: 20,
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff374151),
                ),
                items: ['Latest', 'Oldest', 'Active', 'Expired'].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: controller.changeFilter,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.subscriptions.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Color(0xffD1D5DB)),
                    SizedBox(height: 16),
                    Text(
                      'No subscription history',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6B7280),
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: controller.loadSubscriptionHistory,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.subscriptions.length,
                  itemBuilder: (context, index) {
                    final subscription = controller.subscriptions[index];
                    return SubscriptionCard(
                      paymentDate: subscription.paymentDate,
                      amountPaid: subscription.amountPaid,
                      validityDays: subscription.validityDays,
                      expiryDate: subscription.expiryDate,
                      headerStatus: subscription.headerStatus,
                      footerStatus: subscription.footerStatus,
                      onTap: () {
                        _showReceiptDialog(context, subscription);
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}
