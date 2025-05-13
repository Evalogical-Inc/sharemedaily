import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/custom_icons.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<UserProvider>(builder: (context, dataClass, _) {
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
            'Settings',
            style: textTheme.titleLarge,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Column(
                    children: [
                      _changeCategories(context),
                      _themeButton(context),
                      // _setYourRemeinder(context),
                      // _widgetGuide(context),
                      _aboutus(context),
                      _privacyPolicy(context),
                      if (userProvider.isAuthenticated) _logout(context)
                    ],
                  ),
                ),
              ),
              if (userProvider.isAuthenticated)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20), // Adjust spacing
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeleteAccountDialog(
                          context); // Call delete confirmation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button color
                      foregroundColor: Colors.white, // Text color
                      fixedSize: const Size(200, 50), // Button size
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Curved border
                      ),
                    ),
                    child:
                        dataClass.deleteAccountApiStatus == ApiStatus.isLoading
                            ? const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 16,
                              )
                            : Text("Delete Account",
                                style: TextStyle(fontSize: 16)),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                Response? response =
                    await Provider.of<UserProvider>(context, listen: false)
                        .deleteAccount();
                if (response?.statusCode == 200) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.landing,
                    (Route<dynamic> route) =>
                        false, // Removes all previous routes
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to Logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Navigator.pop(context);
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                await userProvider.logoutUser();
                // Future.delayed(const Duration(seconds: 1), () {
                // Prints after 1 second.
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.landing,
                  (Route<dynamic> route) =>
                      false, // Removes all previous routes
                );
                // });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Widget _themeButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.theme);
      },
      leading: SvgPicture.asset(
        themeProvider.isDarkMode
            ? CustomIcons.settingsThemeDark
            : CustomIcons.settingsTheme,
        width: 22,
      ),
      title: Text(
        'Theme',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 20,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _changeCategories(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.onboardCategory);
      },
      leading: SvgPicture.asset(
        themeProvider.isDarkMode
            ? CustomIcons.settingsCategoryDark
            : CustomIcons.settingsCategory,
        width: 22,
      ),
      title: Text(
        'Change Categories',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 20,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _setYourRemeinder(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.addReminder);
      },
      leading: SvgPicture.asset(
        themeProvider.isDarkMode ? CustomIcons.clockDark : CustomIcons.clock,
        width: 22,
      ),
      title: Text(
        'Set your reminder',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 20,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _widgetGuide(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.widgetGuide);
      },
      leading: SvgPicture.asset(
        themeProvider.isDarkMode
            ? 'assets/images/widget_icon_dark.svg'
            : 'assets/images/widget_icon_light.svg',
        width: 22,
      ),
      title: Text(
        'Widgets',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 20,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _aboutus(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.aboutUs);
      },
      leading: SvgPicture.asset(
        themeProvider.isDarkMode
            ? 'assets/images/profile_about_us_dark.svg'
            : 'assets/images/profile_about_us.svg',
        width: 22,
      ),
      title: Text(
        'About Us',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 20,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _privacyPolicy(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.privacyPolicy);
      },
      leading: SvgPicture.asset(
        themeProvider.isDarkMode
            ? 'assets/images/profile_privacy_policy_dark.svg'
            : 'assets/images/profile_privacy_policy.svg',
        width: 22,
      ),
      title: Text(
        'Privacy & Policy',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 20,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return ListTile(
      onTap: () async {
        _showLogoutDialog(context);
      },
      leading: SvgPicture.asset(
        'assets/images/profile_logout.svg',
        width: 25,
      ),
      trailing: userProvider.logoutUserStatus == ApiStatus.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ),
            )
          : null,
      title: Text(
        'Log Out',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 20,
              color: Colors.red,
            ),
      ),
    );
  }
}
