import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/screens/profile/widgets/profile.image.dart';
import 'package:spresearchvia2/widgets/button.dart';
import 'package:spresearchvia2/widgets/state_selector.dart';
import 'package:spresearchvia2/widgets/title_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userController = Get.put(UserController());

  // Controllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final houseNoController = TextEditingController();
  final streetAddressController = TextEditingController();
  final areaController = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String? selectedState;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = userController.currentUser.value;
    if (user != null) {
      firstNameController.text = user.personalInformation?.firstName ?? '';
      middleNameController.text = user.personalInformation?.middleName ?? '';
      lastNameController.text = user.personalInformation?.lastName ?? '';
      fatherNameController.text = user.personalInformation?.fatherName ?? '';

      houseNoController.text = user.addressDetails?.houseNo ?? '';
      streetAddressController.text = user.addressDetails?.streetAddress ?? '';
      areaController.text = user.addressDetails?.area ?? '';
      landmarkController.text = user.addressDetails?.landmark ?? '';
      pincodeController.text = user.addressDetails?.pincode?.toString() ?? '';
      selectedState = user.addressDetails?.state;

      phoneController.text = user.phone ?? '';
      emailController.text = user.email ?? '';
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Upload image immediately
        await userController.changeProfileImage(_selectedImage!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _saveChanges() async {
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

    final contactDetails = ContactDetails(
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    final success = await userController.updateProfile(
      personalInformation: personalInfo,
      addressDetails: addressDetails,
      contactDetails: contactDetails,
    );

    if (success) {
      Get.back();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        title: Text('Edit Profile', style: AppStyles.appBarTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  child: Column(
                    children: [
                      Obx(() {
                        final user = userController.currentUser.value;
                        return ProfileImageAvatar(
                          imagePath:
                              _selectedImage?.path ??
                              user?.profileImage ??
                              'assets/images/profile_placeholder.jpg',
                        );
                      }),
                      SizedBox(height: 5),
                      Text('Change Photo', style: AppStyles.link),
                    ],
                  ),
                ),
              ),
              TitleField(title: 'First Name', controller: firstNameController),
              SizedBox(height: 5),
              TitleField(
                title: 'Middle Name',
                controller: middleNameController,
              ),
              SizedBox(height: 5),
              TitleField(title: 'Last Name', controller: lastNameController),
              SizedBox(height: 5),
              TitleField(
                title: "Father's Name",
                controller: fatherNameController,
              ),
              SizedBox(height: 5),
              TitleField(title: 'House No', controller: houseNoController),
              SizedBox(height: 5),
              TitleField(
                title: 'Street Address',
                controller: streetAddressController,
              ),
              SizedBox(height: 5),
              TitleField(title: 'Area', controller: areaController),
              SizedBox(height: 5),
              TitleField(title: 'Landmark', controller: landmarkController),
              SizedBox(height: 5),
              TitleField(title: 'Pincode', controller: pincodeController),
              SizedBox(height: 5),
              StateSelector(
                label: selectedState ?? 'Select State',
                onChanged: (newState) =>
                    setState(() => selectedState = newState!),
              ),
              SizedBox(height: 5),
              TitleField(title: 'Mobile Number', controller: phoneController),
              SizedBox(height: 5),
              TitleField(title: 'Email', controller: emailController),
              SizedBox(height: 15),
              Obx(
                () => Button(
                  title: 'Save Changes',
                  buttonType: ButtonType.green,
                  onTap: userController.isLoading.value ? null : _saveChanges,
                ),
              ),

              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Icon(Icons.key, size: 20, color: AppTheme.iconGrey),
                      Expanded(
                        child: Text(
                          'Change Password',
                          style: AppStyles.bodyMedium,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: AppTheme.iconGrey,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 20,
                        color: AppTheme.iconGrey,
                      ),
                      Expanded(
                        child: Text(
                          'Privacy Settings',
                          style: AppStyles.bodyMedium,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: AppTheme.iconGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
