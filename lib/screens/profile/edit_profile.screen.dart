import 'package:flutter/material.dart';
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
  var choosenState = indianStates[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xff11416B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // todo : implement image choosing
                },
                child: Container(
                  child: Column(
                    children: [
                      ProfileImageAvatar(
                        imagePath: 'assets/images/profile_placeholder.jpg',
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Change Photo',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff163174),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TitleField(
                title: 'First Name',
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Middle Name',
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Last Name',
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(
                title: "Father's Name",
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'House No',
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Street Address',
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(title: 'Area', controller: TextEditingController()),
              SizedBox(height: 5),
              TitleField(
                title: 'Landmark',
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(title: 'Pincode', controller: TextEditingController()),
              SizedBox(height: 5),
              StateSelector(
                label: choosenState,
                onChanged: (newState) =>
                    setState(() => choosenState = newState!),
              ),
              SizedBox(height: 5),
              TitleField(
                title: 'Mobile Number',
                controller: TextEditingController(),
              ),
              SizedBox(height: 5),
              TitleField(title: 'Email', controller: TextEditingController()),
              SizedBox(height: 15),
              Button(
                title: 'Save Changes',
                buttonType: ButtonType.green,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Icon(Icons.key, size: 20, color: Color(0xff9CA3AF)),
                      Expanded(
                        child: Text(
                          'Change Password',
                          style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: Color(0xff9CA3AF),
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
                        color: Color(0xff9CA3AF),
                      ),
                      Expanded(
                        child: Text(
                          'Privacy Settings',
                          style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: Color(0xff9CA3AF),
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
