import 'package:flutter/material.dart';

import '../../widgets/button.dart';
import 'widgets/feature.item.dart';
import 'widgets/plan_display.card.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff163174)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose Your Plan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff163174),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xff163174),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 24),

              Text(
                'Unlock Premium Features',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff163174),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),

              Text(
                'Get advanced analytics, unlimited transactions,\nand priority support',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff6B7280),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),

              PlanDisplayCard(
                title: 'Monthly',
                subtitle: 'Billed monthly',
                price: '\$9.99',
                priceUnit: '/month',
                validity: '30-day validity',
              ),
              SizedBox(height: 16),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  PlanDisplayCard(
                    title: 'Annual',
                    subtitle: 'Billed yearly',
                    price: '\$79.99',
                    priceUnit: '/year',
                    originalPrice: '\$119.88',
                    validity: '365-day validity',
                    badge: 'Save 33% • Best Value',
                    isDark: true,
                  ),
                  Positioned(
                    top: -12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffFF8C42), Color(0xffFF6B35)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Most Popular',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              PlanDisplayCard(
                title: 'Custom',
                subtitle: 'Tailored for you',
                price: '\$X.XX',
                priceUnit: '/custom',
                validity: 'Flexible validity',
              ),
              SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What\'s included:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff163174),
                  ),
                ),
              ),
              SizedBox(height: 16),
              FeatureItem(icon: Icons.show_chart, text: 'Advanced Analytics'),
              SizedBox(height: 12),
              FeatureItem(
                icon: Icons.all_inclusive,
                text: 'Unlimited Transactions',
              ),
              SizedBox(height: 12),
              FeatureItem(icon: Icons.headset_mic, text: 'Priority Support'),
              SizedBox(height: 12),
              FeatureItem(icon: Icons.shield, text: 'Enhanced Security'),
              SizedBox(height: 32),

              Button(
                title: 'Choose Plan',
                onTap: () {},
                buttonType: ButtonType.green,
              ),
              SizedBox(height: 12),
              Text(
                'Cancel anytime • 7-day free trial',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff9CA3AF),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
