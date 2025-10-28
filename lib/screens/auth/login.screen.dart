import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/auth/signup.screen.dart';
import 'package:spresearchvia2/screens/tabs.screen.dart';
import 'package:spresearchvia2/widgets/app_logo.dart';
import 'package:spresearchvia2/widgets/button.dart';
import 'package:spresearchvia2/widgets/title_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailPhoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void signIn() {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => TabsScreen()));
    }

    void toSignUpScreen() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignupScreen()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              SizedBox(height: 100, width: double.maxFinite, child: AppLogo()),
              SizedBox(height: 20),
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: Color(0xff11416B),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ),
              Text(
                "Sign in to access your portfolio",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 40),
              TitleField(
                title: 'Email or Phone',
                hint: 'Enter your email or phone',
                controller: emailPhoneController,
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 20),
              TitleField(
                title: 'OTP',
                hint: 'Enter OTP',
                controller: passwordController,
                icon: Icons.visibility_off_outlined,
                isPasswordField: true,
              ),
              SizedBox(height: 50),
              Button(
                title: 'Sign In',
                onTap: signIn,
                buttonType: ButtonType.green,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: toSignUpScreen,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xff11416B),
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              DataProtection(),
            ],
          ),
        ),
      ),
    );
  }
}

class DataProtection extends StatelessWidget {
  const DataProtection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, color: Color(0xff6B7280)),
          Text(
            " Your data is protected with bank-level security",
            style: TextStyle(
              color: Color(0xff6B7280),
              fontSize: 12,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
}
