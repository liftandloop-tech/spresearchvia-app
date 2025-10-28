import 'package:flutter/material.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'widgets/benefits.section.dart';
import 'widgets/change_plan_button.dart';
import 'widgets/current_plan_card.dart';
import 'widgets/expiry_warning_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/renew_button.dart';
import 'widgets/section_header.dart';
import 'widgets/security.footer.dart';

class QuickRenewalScreen extends StatefulWidget {
  const QuickRenewalScreen({super.key});

  @override
  State<QuickRenewalScreen> createState() => _QuickRenewalScreenState();
}

class _QuickRenewalScreenState extends State<QuickRenewalScreen> {
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
          'Quick Renewal',
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpiryWarningCard(
                daysRemaining: dummyUser.daysRemaining,
                message: 'Renew now to continue accessing premium research',
              ),
              SizedBox(height: 24),
              SectionHeader(title: 'Current Plan'),
              SizedBox(height: 12),
              CurrentPlanCard(
                planName: dummyUser.planName,
                description: 'Full access to all reports',
                price:
                    '\$${dummyUser.planAmount}/${dummyUser.planValidity.split(' ')[0].toLowerCase()}',
                validity: dummyUser.planValidity,
                expiryDate:
                    '${dummyUser.subscriptionExpiryDate.month}/${dummyUser.subscriptionExpiryDate.day}/${dummyUser.subscriptionExpiryDate.year}',
              ),
              SizedBox(height: 24),
              SectionHeader(title: 'Payment Method'),
              SizedBox(height: 12),
              PaymentMethodCard(
                cardType: dummyUser.cardType,
                cardNumber: dummyUser.cardNumber,
                expiryDate: 'Expires 12/27',
              ),
              SizedBox(height: 24),
              RenewButton(onPressed: () {}),
              SizedBox(height: 12),
              ChangePlanButton(onPressed: () {}),
              SizedBox(height: 24),
              BenefitsSection(benefits: dummyUser.premiumBenefits),
              SizedBox(height: 24),
              SecurePaymentFooter(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
