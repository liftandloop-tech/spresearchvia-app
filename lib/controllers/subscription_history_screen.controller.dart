import 'package:get/get.dart';
import '../controllers/plan_purchase.controller.dart';
import '../core/models/subscription_history.dart';
import '../services/snackbar.service.dart';

class SubscriptionHistoryScreenController extends GetxController {
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
