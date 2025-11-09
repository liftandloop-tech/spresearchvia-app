import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/screens/tabs.screen.dart';
import 'package:spresearchvia2/widgets/button.dart';

class QuickRenewalScreen extends StatefulWidget {
  const QuickRenewalScreen({super.key});

  @override
  State<QuickRenewalScreen> createState() => _QuickRenewalScreenState();
}

class _QuickRenewalScreenState extends State<QuickRenewalScreen> {
  final planController = Get.find<PlanPurchaseController>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!planController.hasActivePlan) {
        Get.off(() => TabsScreen(initialIndex: 2));
      }
    });

    planController.fetchUserPlan();
  }

  Future<void> _renewPlan() async {
    final plan = planController.currentPlan.value;
    if (plan == null) {
      Get.snackbar('Error', 'No active plan found');
      return;
    }

    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Creating order...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final orderData = await planController.purchasePlan(
        packageName: plan.name,
        amount: plan.amount,
      );

      Get.back();

      if (orderData == null) {
        Get.snackbar(
          'Error',
          'Failed to create renewal order. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.snackbar(
        'Order Created',
        'Renewal order created successfully. You can now proceed with payment.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );

      await planController.fetchUserPlan();
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Failed to initiate renewal: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryBlueDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quick Renewal',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlueDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final plan = planController.currentPlan.value;
        final isLoading = planController.isLoading.value;

        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (plan == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.subscriptions_outlined,
                  size: 64,
                  color: AppTheme.borderGrey,
                ),
                SizedBox(height: 16),
                Text(
                  'No active plan found',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textGrey,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.off(() => TabsScreen(initialIndex: 2)),
                  child: Text('Browse Plans'),
                ),
              ],
            ),
          );
        }

        final daysRemaining = planController.daysRemaining;

        String startDateText = 'N/A';
        if (plan.purchaseDate != null) {
          final start = plan.purchaseDate!;
          startDateText =
              '${start.day.toString().padLeft(2, '0')} ${_getMonthName(start.month)} ${start.year}';
        }

        String expiryDateText = 'N/A';
        if (plan.expiryDate != null) {
          final expiry = plan.expiryDate!;
          expiryDateText =
              '${expiry.day.toString().padLeft(2, '0')} ${_getMonthName(expiry.month)} ${expiry.year}';
        }

        final totalPaid = plan.amount;
        final perDayCost = plan.validityDays > 0
            ? (totalPaid / plan.validityDays).round()
            : 0;

        final completionPercentage = plan.validityDays > 0
            ? ((plan.validityDays - daysRemaining) / plan.validityDays * 100)
                  .clamp(0, 100)
                  .toInt()
            : 0;

        final benefits = plan.features.isNotEmpty
            ? plan.features
            : [
                'Unlimited research reports',
                'Real-time market data',
                'Expert analysis & insights',
              ];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (daysRemaining <= 7)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFFFE5E5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning, color: Color(0xFFE53E3E), size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plan expiring in $daysRemaining days',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFE53E3E),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Renew now to continue accessing premium research',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xFFE53E3E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (daysRemaining <= 7) SizedBox(height: 20),

                Text(
                  'Current Plan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
                SizedBox(height: 16),

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFE2E8F0), width: 3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              plan.name.isNotEmpty
                                  ? plan.name
                                  : 'Index Option – Splendid Plan',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlueDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Active',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      Row(
                        children: [
                          _buildTag('Index Option'),
                          SizedBox(width: 8),
                          _buildTag('Trader'),
                        ],
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Date',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: AppTheme.textGrey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  startDateText,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlueDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Date',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: AppTheme.textGrey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  expiryDateText,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlueDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Per Day Cost',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: AppTheme.textGrey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '₹$perDayCost',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlueDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Paid',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: AppTheme.textGrey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '₹${totalPaid.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Excl. GST',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                        color: AppTheme.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Plan Duration',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppTheme.textGrey,
                                ),
                              ),
                              Text(
                                '$completionPercentage% Complete',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlueDark,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: completionPercentage / 100,
                              minHeight: 8,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _renewPlan,
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text('Renew Plan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.receipt_long, size: 18),
                              label: Text('View Invoice'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryBlueDark,
                                side: BorderSide(color: AppTheme.primaryBlue),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1F71),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            'VISA',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '**** **** **** 4532',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlueDark,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Expires 12/27',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 24,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                Button(
                  title: 'Renew with One Click',
                  buttonType: ButtonType.green,
                  onTap: _renewPlan,
                ),
                SizedBox(height: 16),

                OutlinedButton(
                  onPressed: () => Get.off(() => TabsScreen(initialIndex: 2)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlueDark,
                    side: BorderSide(color: AppTheme.primaryBlue),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Change Plan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What you\'ll continue to get:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                      SizedBox(height: 12),
                      ...benefits
                          .map(
                            (benefit) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF10B981),
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: AppTheme.primaryBlueDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: AppTheme.textGrey, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Secure payment powered by Stripe',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryBlueDark,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
