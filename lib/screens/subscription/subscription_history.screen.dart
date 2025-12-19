import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../core/models/subscription_history.dart';
import 'widgets/subscription_card.dart';
import '../../services/snackbar.service.dart';

class SubscriptionHistoryController extends GetxController {
  final planController = Get.put(PlanPurchaseController());

  final RxString selectedFilter = 'Latest'.obs;
  final RxString selectedSection = 'Registration'.obs; // Registration | Segment

  // registration history mapped to SubscriptionHistory model
  final RxList<SubscriptionHistory> registrations = <SubscriptionHistory>[].obs;
  final RxList<Map<String, dynamic>> registrationsRaw =
      <Map<String, dynamic>>[].obs;

  // segment history raw list (map) - will map to UI when rendering
  final RxList<Map<String, dynamic>> segments = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRegistrationHistory();

    ever(selectedFilter, (_) => _applyFilter());
    ever(selectedSection, (_) {
      if (selectedSection.value == 'Registration') {
        loadRegistrationHistory();
      } else {
        loadSegmentHistory();
      }
    });
  }

  Future<void> loadRegistrationHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    isLoading.value = true;

    try {
      final uid = await planController.userId;
      if (uid == null) {
        SnackbarService.showError('User not logged in');
        return;
      }

      final data = await planController.fetchUserSubscriptionHistoryApi(
        userId: uid,
        page: page,
        pageSize: pageSize,
      );

      final List items = data['userSubcriptionHistory'] ?? [];
      registrationsRaw.value = items
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      final loaded = registrationsRaw.map<SubscriptionHistory>((item) {
        final start = item['startDate'] != null
            ? DateTime.parse(item['startDate']).toString().split(' ')[0]
            : '';
        final end = item['endDate'] != null
            ? DateTime.parse(item['endDate']).toString().split(' ')[0]
            : '';
        final basic = (item['basicAmount'] ?? 0).toString();
        final cgst = (item['cgstAmount'] ?? 0).toString();
        final sgst = (item['sgstAmount'] ?? 0).toString();
        final total =
            double.tryParse(basic.toString()) ??
            0.0 +
                (double.tryParse(cgst.toString()) ?? 0.0) +
                (double.tryParse(sgst.toString()) ?? 0.0);

        return SubscriptionHistory(
          id: item['_id'] ?? '',
          paymentDate: start,
          amountPaid: '₹${total.toStringAsFixed(2)}',
          validityDays: '${item['validity'] ?? ''} days',
          expiryDate: end,
          headerStatus:
              (item['status'] ?? '').toString().toLowerCase() == 'active'
              ? SubscriptionStatus.active
              : (item['status'] ?? '').toString().toLowerCase() == 'expired'
              ? SubscriptionStatus.expired
              : SubscriptionStatus.pending,
          footerStatus:
              (item['status'] ?? '').toString().toLowerCase() == 'failed'
              ? SubscriptionStatus.failed
              : SubscriptionStatus.success,
        );
      }).toList();

      registrations.value = loaded;
      _applyFilter();
    } catch (e) {
      SnackbarService.showError('Failed to load registration history');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSegmentHistory({int page = 1, int pageSize = 20}) async {
    isLoading.value = true;

    try {
      final data = await planController.fetchSegmentsListApi(
        page: page,
        pageSize: pageSize,
      );

      final List items = data['data'] ?? [];
      // store raw segment maps
      segments.value = items
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      SnackbarService.showError('Failed to load segment history');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    // apply filter only to registrations list
    final filtered = _filterSubscriptions(registrations);
    registrations.value = filtered;
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
    BuildContext context, {
    SubscriptionHistory? subscription,
    Map<String, dynamic>? segment,
    Map<String, dynamic>? purchase,
  }) {
    if (subscription != null) {
      if (purchase != null) {
        Get.toNamed(
          '/receipt',
          arguments: {'type': 'registration', 'purchase': purchase},
        );
      } else {
        Get.toNamed(
          '/receipt',
          arguments: {'id': subscription.id, 'type': 'registration'},
        );
      }
    } else if (segment != null) {
      Get.toNamed(
        '/receipt',
        arguments: {'segmentId': segment['_id'], 'type': 'segment'},
      );
    } else {
      Get.toNamed('/receipt');
    }
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          controller.selectedSection.value = 'Registration',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedSection.value == 'Registration'
                              ? Colors.white
                              : const Color(0xffF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xffE5E7EB)),
                        ),
                        child: Center(
                          child: Text(
                            'Registration',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  controller.selectedSection.value ==
                                      'Registration'
                                  ? const Color(0xff163174)
                                  : const Color(0xff6B7280),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedSection.value = 'Segment',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.selectedSection.value == 'Segment'
                              ? Colors.white
                              : const Color(0xffF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xffE5E7EB)),
                        ),
                        child: Center(
                          child: Text(
                            'Segment',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  controller.selectedSection.value == 'Segment'
                                  ? const Color(0xff163174)
                                  : const Color(0xff6B7280),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: controller.selectedSection.value == 'Registration'
                  ? (controller.registrations.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Color(0xffD1D5DB),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No registration history',
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
                            onRefresh: () =>
                                controller.loadRegistrationHistory(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.registrations.length,
                              itemBuilder: (context, index) {
                                final subscription =
                                    controller.registrations[index];
                                return SubscriptionCard(
                                  paymentDate: subscription.paymentDate,
                                  amountPaid: subscription.amountPaid,
                                  validityDays: subscription.validityDays,
                                  expiryDate: subscription.expiryDate,
                                  headerStatus: subscription.headerStatus,
                                  footerStatus: subscription.footerStatus,
                                  onTap: () {
                                    final raw =
                                        controller.registrationsRaw[index];
                                    _showReceiptDialog(
                                      context,
                                      subscription: subscription,
                                      purchase: raw,
                                    );
                                  },
                                );
                              },
                            ),
                          ))
                  : (controller.segments.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Color(0xffD1D5DB),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No segment history',
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
                            onRefresh: () => controller.loadSegmentHistory(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.segments.length,
                              itemBuilder: (context, index) {
                                final segment = controller.segments[index];
                                final paymentDate = segment['createdAt'] != null
                                    ? segment['createdAt'].toString().split(
                                        ' ',
                                      )[0]
                                    : '';
                                final amount =
                                    ((segment['amount'] ?? 0) +
                                            (segment['gstAmount'] ?? 0))
                                        .toString();
                                final validity =
                                    segment['validity']?.toString() ?? '';

                                return SubscriptionCard(
                                  paymentDate: paymentDate,
                                  amountPaid: '₹$amount',
                                  validityDays: validity,
                                  expiryDate: '',
                                  headerStatus: SubscriptionStatus.success,
                                  footerStatus: SubscriptionStatus.success,
                                  onTap: () {
                                    _showReceiptDialog(
                                      context,
                                      segment: segment,
                                    );
                                  },
                                );
                              },
                            ),
                          )),
            ),
          ],
        );
      }),
    );
  }
}
