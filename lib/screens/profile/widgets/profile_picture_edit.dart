import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blur/blur.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/provider/user_provider.dart';

class EditProfilePicture extends StatefulWidget {
  final XFile? imageFile;
  final Function(XFile?) onImagePicked;
  const EditProfilePicture(
      {Key? key, required this.imageFile, required this.onImagePicked})
      : super(key: key);
  @override
  _EditProfilePictureState createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  // Function to show bottom sheet for image selection
  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Library"),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker _picker = ImagePicker();
                final XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  widget.onImagePicked(pickedFile); // Notify the parent widget
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker _picker = ImagePicker();
                final XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);

                if (pickedFile != null) {
                  widget.onImagePicked(pickedFile); // Notify the parent widget
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show full-screen image preview with blur effect
  void _showFullScreenPreview() {
    if (_imageFile == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: Blur(
                blur: 10,
                blurColor: Colors.black.withOpacity(0.5),
                child: Container(color: Colors.transparent),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProfileData, _) {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: widget.imageFile != null
                  ? FileImage(File(widget.imageFile!.path))
                  : NetworkImage(userProfileData.userProfile!.profileImage ??
                      profileImagePlaceholder) as ImageProvider,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: _showImagePickerOptions,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
