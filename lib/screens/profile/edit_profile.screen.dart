import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spresearchvia2/controllers/user.controller.dart';
import 'package:spresearchvia2/core/models/user.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'package:spresearchvia2/core/theme/app_styles.dart';
import 'package:spresearchvia2/core/utils/input_formatters.dart';
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
  final userController = Get.find<UserController>();

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
    print('==========================================');
    print('User ID: ${user?.id}');
    print('User.fullName: ${user?.fullName}');
    print('User.name (getter): ${user?.name}');
    print('User.personalInformation: ${user?.personalInformation}');
    print(
      'User.personalInformation?.firstName: ${user?.personalInformation?.firstName}',
    );
    print('User.addressDetails: ${user?.addressDetails}');
    print('User.phone: ${user?.phone}');
    print('User.email: ${user?.email}');
    print('==========================================');

    if (user != null) {
      setState(() {
        String firstName = user.personalInformation?.firstName ?? '';
        String lastName = user.personalInformation?.lastName ?? '';

        if (firstName.isEmpty &&
            user.fullName != null &&
            user.fullName!.isNotEmpty) {
          final nameParts = user.fullName!.split(' ');
          firstName = nameParts.first;
          if (nameParts.length > 1) {
            lastName = nameParts.last;
          }
        }

        firstNameController.text = firstName;
        middleNameController.text = user.personalInformation?.middleName ?? '';
        lastNameController.text = lastName;
        fatherNameController.text = user.personalInformation?.fatherName ?? '';

        houseNoController.text = user.addressDetails?.houseNo ?? '';
        streetAddressController.text = user.addressDetails?.streetAddress ?? '';
        areaController.text = user.addressDetails?.area ?? '';
        landmarkController.text = user.addressDetails?.landmark ?? '';
        pincodeController.text = user.addressDetails?.pincode?.toString() ?? '';
        selectedState = user.addressDetails?.state;

        phoneController.text =
            user.phone ?? user.contactDetails?.phone?.toString() ?? '';
        emailController.text = user.email ?? user.contactDetails?.email ?? '';
      });
      print(
        'Loaded - First: ${firstNameController.text}, Last: ${lastNameController.text}',
      );
    } else {
      print('User is null!');
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
              TitleField(
                title: 'First Name',
                controller: firstNameController,
                hint: 'Enter first name',
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Middle Name',
                controller: middleNameController,
                hint: 'Enter middle name (optional)',
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Last Name',
                controller: lastNameController,
                hint: 'Enter last name',
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: "Father's Name",
                controller: fatherNameController,
                hint: "Enter father's name (optional)",
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'House No',
                controller: houseNoController,
                hint: 'Enter house number (optional)',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Street Address',
                controller: streetAddressController,
                hint: 'Enter street address',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Area',
                controller: areaController,
                hint: 'Enter area (optional)',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Landmark',
                controller: landmarkController,
                hint: 'Enter landmark (optional)',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Pincode',
                controller: pincodeController,
                hint: 'Enter pincode',
              ),
              SizedBox(height: 5),
              StateSelector(
                label: selectedState ?? 'Select State',
                onChanged: (newState) =>
                    setState(() => selectedState = newState!),
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Mobile Number',
                controller: phoneController,
                hint: 'Enter mobile number',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Email',
                controller: emailController,
                hint: 'Enter email (optional)',
              ),
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
