import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/view_profile.controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_styles.dart';
import '../../core/routes/app_routes.dart';
import 'widgets/profile.image.dart';
import '../../widgets/state_selector.dart';
import '../../widgets/title_field.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewProfileController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        title: const Text('View Profile', style: AppStyles.appBarTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Obx(() {
                        final user =
                            controller.userController.currentUser.value;
                        return ProfileImageAvatar(
                          imagePath:
                              user?.profileImage ??
                              'assets/images/profile_placeholder.jpg',
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () =>
                              _showImageSourceDialog(context, controller),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: AppTheme.backgroundWhite,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: AppTheme.backgroundWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              TitleField(
                title: 'First Name',
                controller: controller.firstNameController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Middle Name',
                controller: controller.middleNameController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Last Name',
                controller: controller.lastNameController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: "Father's Name",
                controller: controller.fatherNameController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'House No',
                controller: controller.houseNoController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Street Address',
                controller: controller.streetAddressController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Area',
                controller: controller.areaController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Landmark',
                controller: controller.landmarkController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Pincode',
                controller: controller.pincodeController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              Obx(
                () => StateSelector(
                  label: controller.selectedState.value ?? 'Not available',
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Mobile Number',
                controller: controller.phoneController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Email',
                controller: controller.emailController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'PAN Number',
                controller: controller.panController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Date of Birth',
                controller: controller.dobController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 5),
              TitleField(
                title: 'Aadhaar Number',
                controller: controller.aadhaarController,
                hint: 'Not available',
                readOnly: true,
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.setMpin);
                },
                child: const SizedBox(
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
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {},
                child: const SizedBox(
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

  void _showImageSourceDialog(
    BuildContext context,
    ViewProfileController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Change Profile Picture', style: AppStyles.heading4),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: AppTheme.primaryBlue,
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImageFromSource(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: AppTheme.primaryBlue,
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImageFromSource(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
