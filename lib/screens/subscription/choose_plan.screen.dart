import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/payment/payment_faliure.screen.dart';
import 'package:spresearchvia2/screens/payment/payment_success.screen.dart';
import 'package:spresearchvia2/screens/subscription/widgets/plan.card.dart';
import 'package:spresearchvia2/widgets/button.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  int selectedPlan = 0;
  final TextEditingController controller = TextEditingController();

  final List<List<dynamic>> plans = [
    ['Basic Plan', 299, 30, false],
    ['Premium Plan', 899, 90, true],
    ['Professional Plan', 1599, 180, false],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan Details',
          style: TextStyle(
            color: Color(0xff11416B),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(
                color: Color(0xff11416B),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            for (int i = 0; i < plans.length; i++) ...[
              PlanCard(
                planName: plans[i][0],
                amount: plans[i][1],
                validity: plans[i][2],
                popular: plans[i][3],
                selected: selectedPlan == i,
                onTap: () => setState(() => selectedPlan = i),
              ),
              const SizedBox(height: 7),
            ],

            CustomPlanCard(
              selected: selectedPlan == plans.length,
              controller: controller,
              onTap: () => setState(() => selectedPlan = plans.length),
            ),

            const SizedBox(height: 25),

            const Text(
              'What’s Included',
              style: TextStyle(
                color: Color(0xff11416B),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            const WhatsNewItem(title: 'Unlimited research reports'),
            const WhatsNewItem(title: 'Real-time market data'),
            const WhatsNewItem(title: 'Expert analysis and insights'),
            const WhatsNewItem(title: '24/7 customer support'),

            const SizedBox(height: 30),

            Button(
              title: 'Proceed To Pay [success]',
              buttonType: ButtonType.green,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PaymentSuccessScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Button(
              title: 'Proceed To Pay [failed]',
              buttonType: ButtonType.green,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PaymentFaliureScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class WhatsNewItem extends StatelessWidget {
  const WhatsNewItem({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xff2C7F38), size: 18),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
