import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../core/models/subscription_history.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/subscription_card.dart';
import '../../services/snackbar.service.dart';

class SubscriptionHistoryController extends GetxController {
  final planController = Get.put(PlanPurchaseController());

  final RxString selectedFilter = 'Latest'.obs;
  final RxString selectedSection = 'Registration'.obs;
  final RxInt selectedTabIndex = 0.obs;

  final RxList<SubscriptionHistory> registrations = <SubscriptionHistory>[].obs;
  final RxList<SubscriptionHistory> allRegistrations =
      <SubscriptionHistory>[].obs;
  final RxList<Map<String, dynamic>> registrationsRaw =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> segments = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

   
  final RxInt registrationPage = 1.obs;
  final RxInt segmentPage = 1.obs;
  final RxBool hasMoreRegistrations = true.obs;
  final RxBool hasMoreSegments = true.obs;
  final int pageSize = 20;

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
    int? page,
    int? pageSize,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (!hasMoreRegistrations.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      registrationPage.value = 1;
      hasMoreRegistrations.value = true;
    }

    try {
      final uid = await planController.userId;
      if (uid == null) {
        SnackbarService.showError('User not logged in');
        return;
      }

      final currentPage = page ?? registrationPage.value;
      final currentPageSize = pageSize ?? this.pageSize;

      final data = await planController.fetchUserSubscriptionHistoryApi(
        userId: uid,
        page: currentPage,
        pageSize: currentPageSize,
      );

      final List items = data['userSubcriptionHistory'] ?? [];

      if (items.isEmpty || items.length < currentPageSize) {
        hasMoreRegistrations.value = false;
      }

      final newRaw = items
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final loaded = newRaw.map<SubscriptionHistory>((item) {
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

      if (loadMore) {
        registrationsRaw.addAll(newRaw);
        allRegistrations.addAll(loaded);
        registrationPage.value++;
      } else {
        registrationsRaw.value = newRaw;
        allRegistrations.value = loaded;
      }

      _applyFilter();
    } catch (e) {
      SnackbarService.showError('Failed to load registration history');
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadSegmentHistory({
    int? page,
    int? pageSize,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (!hasMoreSegments.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      segmentPage.value = 1;
      hasMoreSegments.value = true;
    }

    try {
      final currentPage = page ?? segmentPage.value;
      final currentPageSize = pageSize ?? this.pageSize;

      final data = await planController.fetchSegmentsListApi(
        page: currentPage,
        pageSize: currentPageSize,
      );

      final List items = data['data'] ?? [];

      if (items.isEmpty || items.length < currentPageSize) {
        hasMoreSegments.value = false;
      }

      final newSegments = items
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      if (loadMore) {
        segments.addAll(newSegments);
        segmentPage.value++;
      } else {
        segments.value = newSegments;
      }
    } catch (e) {
      SnackbarService.showError('Failed to load segment history');
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  void _applyFilter() {
    List<SubscriptionHistory> filtered = List.from(allRegistrations);

    switch (selectedFilter.value) {
      case 'Latest':
         
        filtered.sort((a, b) {
          try {
            final dateA = DateTime.tryParse(a.paymentDate);
            final dateB = DateTime.tryParse(b.paymentDate);
            if (dateA == null || dateB == null) return 0;
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });
        break;
      case 'Oldest':
         
        filtered.sort((a, b) {
          try {
            final dateA = DateTime.tryParse(a.paymentDate);
            final dateB = DateTime.tryParse(b.paymentDate);
            if (dateA == null || dateB == null) return 0;
            return dateA.compareTo(dateB);
          } catch (e) {
            return 0;
          }
        });
        break;
      case 'Active':
        filtered = filtered
            .where((s) => s.headerStatus == SubscriptionStatus.active)
            .toList();
         
        filtered.sort((a, b) {
          try {
            final dateA = DateTime.tryParse(a.paymentDate);
            final dateB = DateTime.tryParse(b.paymentDate);
            if (dateA == null || dateB == null) return 0;
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });
        break;
      case 'Expired':
        filtered = filtered
            .where((s) => s.headerStatus == SubscriptionStatus.expired)
            .toList();
         
        filtered.sort((a, b) {
          try {
            final dateA = DateTime.tryParse(a.paymentDate);
            final dateB = DateTime.tryParse(b.paymentDate);
            if (dateA == null || dateB == null) return 0;
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });
        break;
    }

    registrations.value = filtered;
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlueDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Subscription History',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlueDark,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderGrey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(
                () => DropdownButton<String>(
                  value: controller.selectedFilter.value,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.textGrey,
                    size: 20,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textBlack,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: AppTheme.backgroundWhite,
              child: TabBar(
                indicatorColor: AppTheme.primaryBlue,
                indicatorWeight: 3,
                labelColor: AppTheme.primaryBlueDark,
                unselectedLabelColor: AppTheme.textGrey,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Registration'),
                  Tab(text: 'Segment'),
                ],
                onTap: (index) {
                  controller.selectedTabIndex.value = index;
                  controller.selectedSection.value = index == 0
                      ? 'Registration'
                      : 'Segment';
                  if (index == 0) {
                    controller.loadRegistrationHistory();
                  } else {
                    controller.loadSegmentHistory();
                  }
                },
              ),
            ),
          ),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Obx(
                        () => Text(
                          'Filter: ${controller.selectedFilter.value}',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.search,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: [
                    (controller.registrations.isEmpty
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
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!controller.isLoadingMore.value &&
                                    controller.hasMoreRegistrations.value &&
                                    scrollInfo.metrics.pixels >=
                                        scrollInfo.metrics.maxScrollExtent -
                                            200) {
                                  controller.loadRegistrationHistory(
                                    loadMore: true,
                                  );
                                }
                                return false;
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount:
                                    controller.registrations.length +
                                    (controller.isLoadingMore.value ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      controller.registrations.length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
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
                            ),
                          )),

                    (controller.segments.isEmpty
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
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!controller.isLoadingMore.value &&
                                    controller.hasMoreSegments.value &&
                                    scrollInfo.metrics.pixels >=
                                        scrollInfo.metrics.maxScrollExtent -
                                            200) {
                                  controller.loadSegmentHistory(loadMore: true);
                                }
                                return false;
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount:
                                    controller.segments.length +
                                    (controller.isLoadingMore.value ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == controller.segments.length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  final segment = controller.segments[index];
                                  final paymentDate =
                                      segment['createdAt'] != null
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
                            ),
                          )),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
