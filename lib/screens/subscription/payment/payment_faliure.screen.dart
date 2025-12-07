import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/button.dart';

class PaymentFaliureScreen extends StatelessWidget {
  const PaymentFaliureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> errorData = Get.arguments ?? {};
    final String errorMessage = errorData['message'] ?? 'Something went wrong, please try again';

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffFEF2F2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.warning, size: 30, color: Color(0xffEF4444)),
            ),
          ),

          SizedBox(height: 25),
          Text(
            'Payment Failed',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              errorMessage,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
            ),
          ),
          SizedBox(height: 20),
          Button(
            title: 'Retry Payment',
            onTap: () {
              Get.back();
            },
            icon: Icons.refresh,
            buttonType: ButtonType.green,
          ),
          SizedBox(height: 10),
          Button(
            title: 'Back',
            onTap: () {
              Get.offAllNamed(AppRoutes.registrationScreen);
            },
            icon: Icons.arrow_back,
            buttonType: ButtonType.greyBorder,
          ),

          GestureDetector(
            onTap: () {},
            child: Container(
              height: 20,
              child: Text(
                'Need help? Contact support',
                style: TextStyle(fontSize: 12, color: Color(0xff163174)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
