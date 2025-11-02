import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/core/models/subscription_history.dart';
import 'widgets/subscription_card.dart';

class SubscriptionHistoryScreen extends StatefulWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  State<SubscriptionHistoryScreen> createState() =>
      _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState extends State<SubscriptionHistoryScreen> {
  final planController = Get.find<PlanPurchaseController>();
  String selectedFilter = 'Latest';
  List<SubscriptionHistory> subscriptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionHistory();
  }

  Future<void> _loadSubscriptionHistory() async {
    setState(() => isLoading = true);

    try {
      final data = await planController.fetchSubscriptionHistory();
      final loadedSubscriptions = data
          .map((json) => SubscriptionHistory.fromJson(json))
          .toList();

      setState(() {
        subscriptions = _filterSubscriptions(loadedSubscriptions);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Failed to load subscription history');
    }
  }

  List<SubscriptionHistory> _filterSubscriptions(
    List<SubscriptionHistory> subs,
  ) {
    List<SubscriptionHistory> filtered = List.from(subs);

    switch (selectedFilter) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff163174)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
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
            margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffE5E7EB), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedFilter,
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xff6B7280),
                size: 20,
              ),
              style: TextStyle(
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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedFilter = newValue;
                    _loadSubscriptionHistory();
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : subscriptions.isEmpty
          ? Center(
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
              onRefresh: _loadSubscriptionHistory,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final subscription = subscriptions[index];
                  return SubscriptionCard(
                    paymentDate: subscription.paymentDate,
                    amountPaid: subscription.amountPaid,
                    validityDays: subscription.validityDays,
                    expiryDate: subscription.expiryDate,
                    headerStatus: subscription.headerStatus,
                    footerStatus: subscription.footerStatus,
                  );
                },
              ),
            ),
    );
  }
}
