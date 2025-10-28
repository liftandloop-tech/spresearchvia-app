import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/renewal/widgets/expiry_warning_card.dart';
import 'package:spresearchvia2/screens/renewal/widgets/section_header.dart';
import 'package:spresearchvia2/screens/renewal/widgets/current_plan_card.dart';
import 'package:spresearchvia2/screens/renewal/widgets/payment_method_card.dart';
import 'package:spresearchvia2/screens/renewal/widgets/renew_button.dart';
import 'package:spresearchvia2/screens/renewal/widgets/change_plan_button.dart';
import 'package:spresearchvia2/screens/renewal/widgets/benefits_section.dart';
import 'package:spresearchvia2/screens/renewal/widgets/secure_payment_footer.dart';

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpiryWarningCard(
                  daysRemaining: 3,
                  message: 'Renew now to continue accessing premium research',
                ),
                SizedBox(height: 24),
                SectionHeader(title: 'Current Plan'),
                SizedBox(height: 12),
                CurrentPlanCard(
                  planName: 'Premium Research',
                  description: 'Full access to all reports',
                  price: '\$49.99/month',
                  validity: '30 days',
                  expiryDate: 'Jan 28, 2025',
                ),
                SizedBox(height: 24),
                SectionHeader(title: 'Payment Method'),
                SizedBox(height: 12),
                PaymentMethodCard(
                  cardType: 'VISA',
                  cardNumber: '•••• •••• •••• 4532',
                  expiryDate: 'Expires 12/27',
                ),
                SizedBox(height: 24),
                RenewButton(onPressed: () {}),
                SizedBox(height: 12),
                ChangePlanButton(onPressed: () {}),
                SizedBox(height: 24),
                BenefitsSection(
                  benefits: [
                    'Unlimited research reports',
                    'Real-time market data',
                    'Expert analysis & insights',
                  ],
                ),
                SizedBox(height: 24),
                SecurePaymentFooter(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
