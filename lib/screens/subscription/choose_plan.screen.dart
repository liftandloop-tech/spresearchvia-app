import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SPResearchvia/screens/renewal/widgets/current_plan_card.dart';
import '../../controllers/plan_purchase.controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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

              Obx(() {
                final plan = planController.currentPlan.value;
                final isLoading = planController.isLoading.value;

                if (isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlue,
                    ),
                  );
                }

                if (plan == null) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'No active plan found.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: AppTheme.primaryBlueDark,
                        ),
                      ),
                    ),
                  );
                }

                return CurrentPlanCard(
                  description: plan.description ?? 'No description',
                  planName: plan.name,
                  price: plan.amount.toString(),
                  validity: plan.validityDays.toString(),
                  expiryDate: plan.expiryDate.toString(),
                );
              }),

              SizedBox(height: 24),

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
              _buildFeatureItem(Icons.all_inclusive, 'Unlimited Transactions'),
              SizedBox(height: 12),
              _buildFeatureItem(Icons.headset_mic, 'Priority Support'),
              SizedBox(height: 12),
              _buildFeatureItem(Icons.security, 'Enhanced Security'),
              SizedBox(height: 32),

              Button(
                title: 'Choose segment',
                buttonType: ButtonType.green,
                onTap: () {
                  Get.toNamed(AppRoutes.selectSegment);
                },
              ),
              SizedBox(height: 12),

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
