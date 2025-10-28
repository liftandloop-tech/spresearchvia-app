import 'package:flutter/material.dart';
import 'package:spresearchvia2/screens/kyc/kyc_intro.dart';
import 'package:spresearchvia2/screens/auth/login.screen.dart';
import 'package:spresearchvia2/widgets/state_selector.dart';
import 'package:spresearchvia2/widgets/terms_checkbox.dart';

import '../../widgets/app_logo.dart';
import '../../widgets/button.dart';
import '../../widgets/title_field.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? state = null;
  bool otpSent = false;
  bool loading = false;
  bool termsCheck = false;

  void requestOTP() async {
    setState(() {
      loading = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loading = false;
        otpSent = true;
      });
    });
  }

  void signup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const KycIntroScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: AppLogo(),
                ),
                SizedBox(height: 20),
                Text(
                  "Create your account to start lnvesting",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 40),
                Section(title: 'Personal Information'),
                TitleField(
                  title: 'First Name *',
                  hint: 'Enter your first name',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Middle Name',
                  hint: 'Enter your middle name (optional)',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Last Name *',
                  hint: 'Enter your first name',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: "Father's Name *",
                  hint: "Enter your father's name",
                  controller: TextEditingController(),
                ),

                //
                SizedBox(height: 30),
                Section(title: 'Address Details'),
                TitleField(
                  title: 'House No *',
                  hint: 'Enter house number',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Street Address *',
                  hint: 'Enter street address',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Area *',
                  hint: 'Enter area',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Landmark',
                  hint: 'Enter landmark (optional)',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: "Pincode *",
                  hint: "Enter pincode",
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                StateSelector(
                  label: 'State *',
                  onChanged: (value) {
                    if (value != null) state = value;
                  },
                ),

                //
                SizedBox(height: 30),
                Section(title: 'Contact Information'),
                TitleField(
                  title: 'Mobile Number *',
                  hint: 'Enter mobile number',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Email Address *',
                  hint: 'Enter email address',
                  controller: TextEditingController(),
                ),

                Visibility(
                  visible: otpSent,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Section(title: 'Security'),
                      TitleField(
                        title: 'OTP *',
                        hint: 'Enter OTP',
                        controller: TextEditingController(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TermsCheckbox(
                  value: termsCheck,
                  onChanged: (value) {
                    setState(() {
                      termsCheck = value!;
                    });
                  },
                  onTermsTap: () {},
                  onPrivacyTap: () {},
                ),
                SizedBox(height: 50),
                Button(
                  buttonType: ButtonType.green,
                  title: loading
                      ? 'Loading...'
                      : otpSent
                      ? 'Verify & Sign Up'
                      : 'Request OTP',
                  icon: loading
                      ? null
                      : otpSent
                      ? Icons.person_add
                      : Icons.password,
                  onTap: loading
                      ? null
                      : () {
                          otpSent ? signup() : requestOTP();
                        },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

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

class Section extends StatelessWidget {
  Section({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff11416B),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
            ),
          ),
          Divider(color: Color(0xffE5E7EB)),
        ],
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
