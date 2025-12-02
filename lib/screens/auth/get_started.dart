import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlueDark,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(Icons.light, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'SP ResearchVia',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to SP ResearchVia - Your Trusted Market Research Partner',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
            ),
            SizedBox(height: 20),
            SizedBox(child: Image.asset('assets/images/get_started.png')),
            SizedBox(height: 20),
            Text(
              'Get Started',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Button(
              title: 'Existing Customer - Login',
              icon: Icons.login,
              buttonType: ButtonType.blue,
              onTap: () {
                Get.toNamed(AppRoutes.login);
              },
            ),
            SizedBox(height: 10),
            Button(
              title: 'New Customer - Sign Up',
              icon: Icons.person_add,
              buttonType: ButtonType.green,
              onTap: () {
                Get.toNamed(AppRoutes.signup);
              },
            ),
            SizedBox(height: 10),
            Text(
              'By continuing, you agree to our Terms & Privacy Policy.',
              style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
