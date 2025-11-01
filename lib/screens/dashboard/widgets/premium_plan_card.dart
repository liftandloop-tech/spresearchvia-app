import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spresearchvia2/controllers/plan_purchase.controller.dart';
import 'package:spresearchvia2/screens/subscription/quick_renewal.screen.dart';

import '../../../widgets/button.dart';

class PremiumPlanCard extends StatelessWidget {
  const PremiumPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<PlanPurchaseController>()) {
      Get.put(PlanPurchaseController());
    }

    return GetX<PlanPurchaseController>(
      builder: (controller) {
        final plan = controller.currentPlan.value;
        final hasActivePlan = controller.hasActivePlan;
        final daysRemaining = controller.daysRemaining;

        // If no active plan, show "No active plan" card
        if (plan == null || !hasActivePlan) {
          return Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff6B7280), Color(0xff4B5563)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'No Active Plan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff9CA3AF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Inactive',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Subscribe to a plan to access premium features',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 24),
                Button(
                  title: 'Subscribe Now',
                  icon: Icons.star,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuickRenewalScreen(),
                      ),
                    );
                  },
                  buttonType: ButtonType.green,
                ),
              ],
            ),
          );
        }

        // Active plan card
        final expiryDate = plan.expiryDate;
        final formattedExpiry = expiryDate != null
            ? DateFormat('MMMM dd, yyyy').format(expiryDate)
            : 'N/A';

        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff1E4A7C), Color(0xff0D2847)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan.name.isNotEmpty ? plan.name : 'Premium Plan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xff2C4D6F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    daysRemaining.toString(),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      daysRemaining == 1 ? 'day left' : 'days left',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Expires on $formattedExpiry',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 24),
              Button(
                title: 'Renew Now',
                icon: Icons.refresh,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuickRenewalScreen(),
                    ),
                  );
                },
                buttonType: ButtonType.green,
              ),
            ],
          ),
        );
      },
    );
  }
}
