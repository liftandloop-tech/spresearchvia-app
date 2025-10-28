import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'widgets/subscription_card.dart';

class SubscriptionHistoryScreen extends StatefulWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  State<SubscriptionHistoryScreen> createState() =>
      _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState extends State<SubscriptionHistoryScreen> {
  String selectedFilter = 'Latest';

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
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: dummyUser.subscriptionHistory.length,
        itemBuilder: (context, index) {
          final subscription = dummyUser.subscriptionHistory[index];
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
    );
  }
}
