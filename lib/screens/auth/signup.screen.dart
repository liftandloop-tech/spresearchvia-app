import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/controllers/auth.controller.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/core/utils/validators.dart';
import 'package:spresearchvia2/core/utils/input_formatters.dart';
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
  final authController = Get.find<AuthController>();

  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();

  final houseNoController = TextEditingController();
  final streetAddressController = TextEditingController();
  final areaController = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeController = TextEditingController();
  String? selectedState;

  final phoneController = TextEditingController();
  final emailController = TextEditingController();

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
    super.dispose();
  }

  Future<void> signup() async {
    if (!_validateFields()) return;

    if (!termsCheck) {
      Get.snackbar('Error', 'Please accept terms and conditions');
      return;
    }

    String getPhoneWithCountryCode(String phone) {
      final cleaned = Validators.cleanPhone(phone);
      if (cleaned.startsWith('+91')) return cleaned;
      if (cleaned.length == 10) return '+91$cleaned';
      return cleaned;
    }

    final phone = getPhoneWithCountryCode(phoneController.text.trim());

    final personalInfo = PersonalInformation(
      firstName: firstNameController.text.trim(),
      middleName: middleNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      fatherName: fatherNameController.text.trim(),
    );

    final addressDetails = AddressDetails(
      houseNo: houseNoController.text.trim(),
      streetAddress: streetAddressController.text.trim(),
      area: areaController.text.trim(),
      landmark: landmarkController.text.trim(),
      pincode: pincodeController.text.trim(),
      state: selectedState,
    );

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
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final fatherName = fatherNameController.text.trim();
    final houseNo = houseNoController.text.trim();
    final streetAddress = streetAddressController.text.trim();
    final area = areaController.text.trim();
    final pincode = pincodeController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    final nameValidation = Validators.validateName(
      firstName,
      fieldName: 'First name',
    );
    if (nameValidation != null) {
      Get.snackbar('Error', nameValidation);
      return false;
    }

    final lastNameValidation = Validators.validateName(
      lastName,
      fieldName: 'Last name',
    );
    if (lastNameValidation != null) {
      Get.snackbar('Error', lastNameValidation);
      return false;
    }

    final fatherNameValidation = Validators.validateName(
      fatherName,
      fieldName: "Father's name",
    );
    if (fatherNameValidation != null) {
      Get.snackbar('Error', fatherNameValidation);
      return false;
    }

    if (houseNo.isEmpty) {
      Get.snackbar('Error', 'Please enter house number');
      return false;
    }

    if (streetAddress.isEmpty) {
      Get.snackbar('Error', 'Please enter street address');
      return false;
    }

    if (area.isEmpty) {
      Get.snackbar('Error', 'Please enter area');
      return false;
    }

    final pincodeValidation = Validators.validatePincode(pincode);
    if (pincodeValidation != null) {
      Get.snackbar('Error', pincodeValidation);
      return false;
    }

    if (selectedState == null) {
      Get.snackbar('Error', 'Please select state');
      return false;
    }

    final phoneValidation = Validators.validatePhone(phone);
    if (phoneValidation != null) {
      Get.snackbar('Error', phoneValidation);
      return false;
    }

    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      Get.snackbar('Error', emailValidation);
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
                  inputFormatters: [NameInputFormatter()],
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Middle Name',
                  hint: 'Enter your middle name (optional)',
                  controller: middleNameController,
                  inputFormatters: [NameInputFormatter()],
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Last Name *',
                  hint: 'Enter your first name',
                  controller: lastNameController,
                  inputFormatters: [NameInputFormatter()],
                ),
                SizedBox(height: 20),
                TitleField(
                  title: "Father's Name *",
                  hint: "Enter your father's name",
                  controller: fatherNameController,
                  inputFormatters: [NameInputFormatter()],
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
                  inputFormatters: [PincodeInputFormatter()],
                  keyboardType: TextInputType.number,
                  maxLength: 6,
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

                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                ),
                SizedBox(height: 20),
                TitleField(
                  title: 'Email Address *',
                  hint: 'Enter email address',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
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
                        : 'Sign Up',
                    icon: authController.isLoading.value
                        ? null
                        : Icons.person_add,
                    onTap: authController.isLoading.value ? null : signup,
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
