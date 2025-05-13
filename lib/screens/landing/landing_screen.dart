import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:provider/provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
// import 'package:quotify/screens/add_reminder/add_reminder_screen.dart';
import 'package:quotify/screens/home/home_screen.dart';
import 'package:quotify/screens/login/login.dart';
import 'package:quotify/screens/profile/profile_screen.dart';
import 'package:quotify/screens/quotes/quotes_screen.dart';
import 'package:quotify/screens/search/search_screen_home.dart';
import 'package:quotify/widgets/app_bottom_navigation_bar.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  final newVersion = NewVersionPlus(
    androidId: 'com.evalogical.sharemedaily', 
    iOSId: 'com.evalogical.sharemedaily',     
  );


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        bottomNavigationIndex.value = 3;
      }
      checkForUpdate();
    });
  }

  Future<void> checkForUpdate() async {
    final status = await newVersion.getVersionStatus();

    if (!mounted || status == null || !status.canUpdate) return;

    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: 'Update Available',
      dialogText:
          'A newer version (${status.storeVersion}) is available!\nYou are currently on ${status.localVersion}.',
      updateButtonText: 'Update',
      dismissButtonText: 'Later',
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final List<Widget> screens = [
      const HomeScreen(),
      const SearchScreenHome(),
      const QuotesScreen(),
      userProvider.isAuthenticated
          ? ProfileScreen(
              args: args,
            )
          : LoginScreen(
              arguments: LoginArguments(isOnboarding: false),
            ),
    ];

    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: bottomNavigationIndex,
        builder: (context, index, _) {
          return screens[index];
        },
      ),
      bottomNavigationBar: Consumer<ThemeProvier>(
        builder: (context, value, child) => AppBttomNavigationBar(),
      ),
    );
  }
}
