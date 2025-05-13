import 'dart:io';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/models/user_profile_res_model.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quotify/screens/profile/widgets/profile_edit_modal.dart';
import 'package:quotify/theme/app_theme.dart';

class ProfileHeaderWidget extends StatefulWidget {
  const ProfileHeaderWidget({Key? key}) : super(key: key);

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    void showFullScreenPreview(String? imageUrl) {
      if (imageUrl == null) return;
      showDialog(
        context: context,
        builder: (context) {
          return Stack(
            children: [
              // Blurred background
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Blur(
                    blur: 10,
                    // blurColor: Colors.black.withValues(),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 250.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(imageUrl))),
                ),
              ),
            ],
          );
        },
      );
    }

    return Consumer<UserProvider>(builder: (context, userProfileData, _) {
      ProfileResModel? userProfile = userProfileData.userProfile;

      print('---- user profile ---- ${userProfile?.profileImage}');
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: double.infinity,
        // decoration: const BoxDecoration(color: Colors.red),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            showFullScreenPreview(userProfile?.profileImage),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors
                              .grey[300], // Background color while loading
                          backgroundImage: CachedNetworkImageProvider(
                            userProfile?.profileImage ??
                                profileImagePlaceholder,
                          ),
                          onBackgroundImageError: (_, __) => debugPrint(
                              "Image loading error"), // Error handling
                          child: userProfile?.profileImage == null
                              ? const Icon(Icons.account_circle,
                                  size: 80,
                                  color: Colors.grey) // Placeholder icon
                              : null, // Remove child when image is loaded
                        ),
                      ),
                      AppSpacing.width20,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userProfile?.firstName == null
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${userProfileData?.userProfile?.firstName} ${userProfileData?.userProfile?.lastName ?? ''}',
                                      style: textTheme.titleLarge,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.profileEdit);
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: AppColors.defaultGrey,
                                          ),
                                          AppSpacing.width5,
                                          Text(
                                            'edit',
                                            style: textTheme.bodySmall,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      themeProvider.isDarkMode
                          ? 'assets/images/profile_settings_dark.svg'
                          : 'assets/images/profile_settings.svg',
                      width: 22,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
