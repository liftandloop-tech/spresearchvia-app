import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/widgets/button.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  final planController = Get.find<PlanPurchaseController>();

  @override
  void initState() {
    super.initState();
    planController.fetchUserPlan();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
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
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
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
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Choose Your Segment',
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

        if (isLoading && plan == null) {
          return Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlue),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Crown Icon
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlueDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Unlock Premium Features',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlueDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Subtitle
                Text(
                  'Get advanced analytics, unlimited transactions,\nand priority support',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppTheme.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Current Plan Card (if exists)
                if (plan != null && plan.isActive) _buildCurrentPlanCard(plan),

                SizedBox(height: 24),

                // What's Included
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'What\'s included:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlueDark,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                _buildFeatureItem(Icons.show_chart, 'Advanced Analytics'),
                SizedBox(height: 12),
                _buildFeatureItem(
                  Icons.all_inclusive,
                  'Unlimited Transactions',
                ),
                SizedBox(height: 12),
                _buildFeatureItem(Icons.headset_mic, 'Priority Support'),
                SizedBox(height: 12),
                _buildFeatureItem(Icons.security, 'Enhanced Security'),
                SizedBox(height: 32),

                // Choose Segment Button
                Button(
                  title: 'Choose segment',
                  buttonType: ButtonType.green,
                  onTap: () {
                    // Navigate to plan selection
                    Get.toNamed('/choose-plan-details');
                  },
                ),
                SizedBox(height: 12),

                // Footer Text
                Text(
                  'Cancel anytime â€¢ 7-day free trial',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppTheme.textGrey,
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

  Widget _buildCurrentPlanCard(Plan plan) {
    final daysRemaining = planController.daysRemaining;
    final totalDays = plan.validityDays;
    final completionPercentage = totalDays > 0
        ? ((totalDays - daysRemaining) / totalDays * 100).clamp(0, 100).toInt()
        : 0;
    final perDayCost = totalDays > 0 ? (plan.amount / totalDays).round() : 0;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF11416B), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Name with Active Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name.isNotEmpty
                      ? plan.name
                      : 'Index Option â€“ Splendid Plan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlueDark,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                        fontSize: 11,
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

          // Plan Type Tags
          Row(
            children: [
              _buildTag('Index Option'),
              SizedBox(width: 8),
              _buildTag('Trader'),
            ],
          ),
          SizedBox(height: 16),

          // Dates Row
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
                        fontSize: 11,
                        color: AppTheme.textGrey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatDate(plan.purchaseDate),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
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
                        fontSize: 11,
                        color: AppTheme.textGrey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatDate(plan.expiryDate),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Cost Row
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
                        fontSize: 11,
                        color: AppTheme.textGrey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'â‚¹$perDayCost',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
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
                        fontSize: 11,
                        color: AppTheme.textGrey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'â‚¹${plan.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Excl. GST',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9,
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
          SizedBox(height: 16),

          // Progress Bar
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
                      fontSize: 11,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  Text(
                    '$completionPercentage% Complete',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
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
                  minHeight: 6,
                  backgroundColor: Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to renewal
                  },
                  icon: Icon(Icons.refresh, size: 16),
                  label: Text('Renew Plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.receipt_long, size: 16),
                  label: Text('View Invoice'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlueDark,
                    side: BorderSide(color: AppTheme.primaryBlue),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryBlueDark,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF10B981), size: 20),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppTheme.primaryBlueDark,
          ),
        ),
      ],
    );
  }
}
