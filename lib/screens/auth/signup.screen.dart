import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/auth.controller.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
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
  final authController = Get.put(AuthController());

  // Personal Information Controllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();

  // Address Controllers
  final houseNoController = TextEditingController();
  final streetAddressController = TextEditingController();
  final areaController = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeController = TextEditingController();
  String? selectedState;

  // Contact Controllers
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  bool termsCheck = false;

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    fatherNameController.dispose();
    houseNoController.dispose();
    streetAddressController.dispose();
    areaController.dispose();
    landmarkController.dispose();
    pincodeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> requestOTP() async {
    // Validate required fields
    if (!_validateFields()) return;

    final phone = phoneController.text.trim();
    await authController.sendOtp(phone);
  }

  Future<void> signup() async {
    if (!_validateFields()) return;

    if (!termsCheck) {
      Get.snackbar('Error', 'Please accept terms and conditions');
      return;
    }

    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP');
      return;
    }

    // Create personal information
    final personalInfo = PersonalInformation(
      firstName: firstNameController.text.trim(),
      middleName: middleNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      fatherName: fatherNameController.text.trim(),
    );

    // Create address details
    final addressDetails = AddressDetails(
      houseNo: houseNoController.text.trim(),
      streetAddress: streetAddressController.text.trim(),
      area: areaController.text.trim(),
      landmark: landmarkController.text.trim(),
      pincode: pincodeController.text.trim(),
      state: selectedState,
    );

    // First verify OTP
    final otpVerified = await authController.verifyOtp(phone, otp);

    if (!otpVerified) return;

    // Then create user with full details
    final success = await authController.createUser(
      fullName: '${firstNameController.text} ${lastNameController.text}',
      email: emailController.text.trim(),
      phone: phone,
      termsCondition: termsCheck,
      personalInformation: personalInfo,
      addressDetails: addressDetails,
    );

    if (success) {
      Get.off(() => const KycIntroScreen());
    }
  }

  bool _validateFields() {
    if (firstNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter first name');
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter last name');
      return false;
    }
    if (fatherNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter father\'s name');
      return false;
    }
    if (houseNoController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter house number');
      return false;
    }
    if (streetAddressController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter street address');
      return false;
    }
    if (areaController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter area');
      return false;
    }
    if (pincodeController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter pincode');
      return false;
    }
    if (selectedState == null) {
      Get.snackbar('Error', 'Please select state');
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter mobile number');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter email address');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
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
                  style: AppStyles.bodyMedium,
                ),
                SizedBox(height: 40),
                Section(title: 'Personal Information'),
                TitleField(
                  title: 'First Name *',
                  hint: 'Enter your first name',
                  controller: firstNameController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Middle Name',
                  hint: 'Enter your middle name (optional)',
                  controller: middleNameController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Last Name *',
                  hint: 'Enter your first name',
                  controller: lastNameController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: "Father's Name *",
                  hint: "Enter your father's name",
                  controller: fatherNameController,
                ),

                //
                SizedBox(height: 30),
                Section(title: 'Address Details'),
                TitleField(
                  title: 'House No *',
                  hint: 'Enter house number',
                  controller: houseNoController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Street Address *',
                  hint: 'Enter street address',
                  controller: streetAddressController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Area *',
                  hint: 'Enter area',
                  controller: areaController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Landmark',
                  hint: 'Enter landmark (optional)',
                  controller: landmarkController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: "Pincode *",
                  hint: "Enter pincode",
                  controller: pincodeController,
                ),
                SizedBox(height: 20),
                StateSelector(
                  label: 'State *',
                  onChanged: (value) {
                    setState(() {
                      selectedState = value;
                    });
                  },
                ),

                //
                SizedBox(height: 30),
                Section(title: 'Contact Information'),
                TitleField(
                  title: 'Mobile Number *',
                  hint: 'Enter mobile number',
                  controller: phoneController,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Email Address *',
                  hint: 'Enter email address',
                  controller: emailController,
                ),

                Obx(
                  () => Visibility(
                    visible: authController.isOtpSent.value,
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Section(title: 'Security'),
                        TitleField(
                          title: 'OTP *',
                          hint: 'Enter OTP',
                          controller: otpController,
                        ),
                      ],
                    ),
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
                Obx(
                  () => Button(
                    buttonType: ButtonType.green,
                    title: authController.isLoading.value
                        ? 'Loading...'
                        : authController.isOtpSent.value
                        ? 'Verify & Sign Up'
                        : 'Request OTP',
                    icon: authController.isLoading.value
                        ? null
                        : authController.isOtpSent.value
                        ? Icons.person_add
                        : Icons.password,
                    onTap: authController.isLoading.value
                        ? null
                        : () {
                            authController.isOtpSent.value
                                ? signup()
                                : requestOTP();
                          },
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.off(() => const LoginScreen());
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppStyles.bodyMedium,
                        ),
                        Text("Sign In", style: AppStyles.link),
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
          Text(title, style: AppStyles.heading3),
          Divider(color: AppTheme.dividerGrey),
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
          Icon(Icons.shield_outlined, color: AppTheme.textGrey),
          Text(
            " Your data is protected with bank-level security",
            style: AppStyles.caption,
          ),
        ],
      ),
    );
  }
}
