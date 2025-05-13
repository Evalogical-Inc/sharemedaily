import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quotify/models/user_profile_res_model.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/screens/profile/widgets/phone_number_edit.dart';
import 'package:quotify/screens/profile/widgets/profile_picture_edit.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  XFile? _imageFile;
  void _handleImagPicked(XFile? image) {
    log('Image Picked: $image');
    setState(() {
      _imageFile = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<UserProvider>(builder: (context, userProfileData, _) {
      ProfileResModel? userProfile = userProfileData.userProfile;
      final TextEditingController firstNameController =
          TextEditingController(text: userProfile?.firstName);
      final TextEditingController lastNameController =
          TextEditingController(text: userProfile?.lastName);
      final TextEditingController phoneController =
          TextEditingController(text: userProfile?.phoneNumber);
      final TextEditingController emailController =
          TextEditingController(text: userProfile?.email);
      final TextEditingController bioController =
          TextEditingController(text: userProfile?.bio);
      String? selectedGender = userProfile?.gender ?? 'Male';
      final _formKey = GlobalKey<FormState>();
      return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color:
                  Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          title: Text(
            'Edit Profile',
            style: textTheme.titleLarge,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  EditProfilePicture(
                    imageFile: _imageFile,
                    onImagePicked: _handleImagPicked,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: firstNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[ ]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      } else if (value.length < 3) {
                        return 'First name must be at least 3 characters';
                      } else if (value.length > 20) {
                        return 'First name must not exceed 20 characters';
                      }
                      return null; // Validation passed
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: lastNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[ ]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // return 'First name is required';
                      } else if (value.length > 20) {
                        return 'Last name must not exceed 20 characters';
                      }
                      return null; // Validation passed
                    },
                  ),
                  // TextField(
                  //   controller: lastNameController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Last Name',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PhoneNumberInput(
                    phoneController: phoneController,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Provider.of<ThemeProvier>(context).isDarkMode
                            ? Colors.white // Light text on dark theme
                            : Colors.black), // Dark text on light theme),
                    value: selectedGender,
                    onChanged: (value) {
                      log(value.toString());
                      selectedGender = value;
                    },
                    items: ['Male', 'Female'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                      hintText: 'Tell us about yourself...',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: userProvider.isProfileUpdating
                            ? null // Disable button while updating
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  Response? response =
                                      await userProvider.editUserPorifile(
                                    firstNameController.text,
                                    lastNameController.text,
                                    phoneController.text,
                                    _imageFile,
                                    bioController.text,
                                    selectedGender ?? '',
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(response?.statusCode == 200
                                          ? 'Profile updated successfully'
                                          : 'Something went wrong'),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: userProvider.isProfileUpdating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
