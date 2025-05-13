import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/custom_icons.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/widgets/circle_button.dart';


ValueNotifier<int> bottomNavigationIndex = ValueNotifier(0);

class AppBttomNavigationBar extends StatelessWidget {
  const AppBttomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bottomNavigationIndex,
      builder: (context, currentIndex, _) {
        return Consumer2<ThemeProvier, UserProvider>(
            builder: (context, themeProvier, userProvider, _) {
          return Theme(
            data: ThemeData(splashColor: Colors.transparent),
            child: BottomNavigationBar(
              backgroundColor: themeProvier.isDarkMode ? AppColors.black : AppColors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              onTap: (selectedIndex) {
                bottomNavigationIndex.value = selectedIndex;
              },
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    bottomNavigationIndex.value == 0
                        ? themeProvier.isDarkMode
                            ? CustomIcons.homeDarkSelected
                            : CustomIcons.homeSelected
                        : themeProvier.isDarkMode
                            ? CustomIcons.homeDark
                            : CustomIcons.home,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    bottomNavigationIndex.value == 1
                        ? themeProvier.isDarkMode
                            ? CustomIcons.searchDarkSelected
                            : CustomIcons.searchSelected
                        : themeProvier.isDarkMode
                            ? CustomIcons.searchDark
                            : CustomIcons.search,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    bottomNavigationIndex.value == 2
                        ? themeProvier.isDarkMode
                            ? CustomIcons.cardDarkSelected
                            : CustomIcons.cardSelected
                        : themeProvier.isDarkMode
                            ? CustomIcons.cardDark
                            : CustomIcons.card,
                  ),
                  label: '',
                ),
                // BottomNavigationBarItem(
                //   icon: SvgPicture.asset(
                //     bottomNavigationIndex.value == 3
                //         ? themeProvier.isDarkMode
                //             ? CustomIcons.clockDarkSelected
                //             : CustomIcons.clockSelected
                //         : themeProvier.isDarkMode
                //             ? CustomIcons.clockDark
                //             : CustomIcons.clockLight,
                //   ),
                //   label: '',
                // ),
                // BottomNavigationBarItem(
                //   icon: SvgPicture.asset(
                //     bottomNavigationIndex.value == 3
                //         ? themeProvier.isDarkMode
                //             ? CustomIcons.favoriteDarkSelected
                //             : CustomIcons.favoriteSelected
                //         : themeProvier.isDarkMode
                //             ? CustomIcons.favoriteDark
                //             : CustomIcons.favorite,
                //   ),
                //   label: '',
                // ),
                if (userProvider.isAuthenticated && (userProvider.userProfile?.profileImage ?? '').isNotEmpty)
                  BottomNavigationBarItem(
                    icon: CircleButton(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      diameter: 30,
                      child: CachedNetworkImage(
                        imageUrl: userProvider.userProfile?.profileImage,
                        fit: BoxFit.cover,
                        width: 30,
                        height: 30,
                        placeholder: (context, url) => Icon(
                          Icons.account_circle,
                        ), // Show loading indicator
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error), // Show error icon if image fails
                      ),
                    ),
                    label: '',
                  )
                else
                  BottomNavigationBarItem(
                    icon: CircleButton(
                      backgroundColor:
                          Colors.white,
                      diameter: 30,
                      child: const Icon(
                        Icons.account_circle,
                      ),
                    ),
                    label: '',
                  )
              ],
            ),
          );
        });
      },
    );
  }
}
