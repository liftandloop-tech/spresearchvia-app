import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user.controller.dart';
import '../core/models/user.dart';
import '../core/utils/error_message_handler.dart';
import '../services/snackbar.service.dart';

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

    final addressInfo = AddressDetails(
      houseNo: houseNoController.text.trim(),
      streetAddress: streetAddressController.text.trim(),
      area: areaController.text.trim(),
      landmark: landmarkController.text.trim(),
      pincode: int.tryParse(pincodeController.text.trim()) ?? 0,
      state: selectedState.value ?? '',
    );

    final contactInfo = ContactDetails(
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
    );

    try {
      final success = await userController.updateProfile(
        personalInformation: personalInfo,
        addressDetails: addressInfo,
        contactDetails: contactInfo,
      );

      if (success) {
        SnackbarService.showSuccess('Profile updated successfully!');
        Get.back();
      } else {
        SnackbarService.showError('Failed to update profile');
      }
    } catch (e) {
      ErrorMessageHandler.logError('Update Profile', e);
      SnackbarService.showErrorFromException(e, title: 'Failed to Save');
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
