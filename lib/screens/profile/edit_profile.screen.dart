import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/user.controller.dart';
import '../../core/models/user.dart';
import '../../core/utils/error_message_handler.dart';
import '../../services/snackbar.service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_styles.dart';
import '../../core/utils/input_formatters.dart';
import 'widgets/profile.image.dart';
import '../../widgets/button.dart';
import '../../widgets/state_selector.dart';
import '../../widgets/title_field.dart';

class EditProfileController extends GetxController {
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

  final Rxn<String> selectedState = Rxn<String>();
  final Rxn<File> selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final user = userController.currentUser.value;

    if (user != null) {
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
      selectedState.value = user.addressDetails?.state;

      phoneController.text =
          user.phone ?? user.contactDetails?.phone?.toString() ?? '';
      emailController.text = user.email ?? user.contactDetails?.email ?? '';
    }
  }

  Future<void> pickImageFromSource(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        await userController.changeProfileImage(selectedImage.value!);
      }
    } catch (e) {
      ErrorMessageHandler.logError('Pick Image', e);
      SnackbarService.showErrorFromException(e, title: 'Failed to Pick Image');
    }
  }

  Future<void> saveChanges() async {
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
      state: selectedState.value,
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
  void onClose() {
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
    super.onClose();
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  void _showImagePickerBottomSheet(
    BuildContext context,
    EditProfileController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xffE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Change Profile Picture',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff163174),
                  ),
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImageFromSource(ImageSource.camera);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffE5E7EB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff163174),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Take Photo',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff163174),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImageFromSource(ImageSource.gallery);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffE5E7EB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff163174),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Upload from Gallery',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff163174),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xffF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

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
                onTap: () => _showImagePickerBottomSheet(context, controller),
                child: Container(
                  child: Column(
                    children: [
                      Obx(() {
                        final user =
                            controller.userController.currentUser.value;
                        return ProfileImageAvatar(
                          imagePath:
                              controller.selectedImage.value?.path ??
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
                controller: controller.firstNameController,
                hint: 'Enter first name',
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Middle Name',
                controller: controller.middleNameController,
                hint: 'Enter middle name (optional)',
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Last Name',
                controller: controller.lastNameController,
                hint: 'Enter last name',
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: "Father's Name",
                controller: controller.fatherNameController,
                hint: "Enter father's name (optional)",
                inputFormatters: [NameInputFormatter()],
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'House No',
                controller: controller.houseNoController,
                hint: 'Enter house number (optional)',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Street Address',
                controller: controller.streetAddressController,
                hint: 'Enter street address',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Area',
                controller: controller.areaController,
                hint: 'Enter area (optional)',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Landmark',
                controller: controller.landmarkController,
                hint: 'Enter landmark (optional)',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Pincode',
                controller: controller.pincodeController,
                hint: 'Enter pincode',
              ),
              SizedBox(height: 5),
              Obx(
                () => StateSelector(
                  label: controller.selectedState.value ?? 'Select State',
                  onChanged: (newState) =>
                      controller.selectedState.value = newState!,
                ),
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Mobile Number',
                controller: controller.phoneController,
                hint: 'Enter mobile number',
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Email',
                controller: controller.emailController,
                hint: 'Enter email (optional)',
              ),
              SizedBox(height: 15),
              Obx(
                () => Button(
                  title: 'Save Changes',
                  buttonType: ButtonType.green,
                  onTap: controller.userController.isLoading.value
                      ? null
                      : controller.saveChanges,
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
