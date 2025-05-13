import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/globals/ad_manager.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/system_theme.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/models/token_data_model.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/login/login.dart';
import 'package:quotify/utilities/user_util.dart';
import 'package:quotify/widgets/fade_in_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CategoryProvider categoryProvider =
      Provider.of<CategoryProvider>(scaffoldKey.currentContext!, listen: false);
  Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).getUserPorifile();
      streamSubscription =
          connectivity.onConnectivityChanged.listen((connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          Future.delayed(Duration.zero, () async {
            var connectionResult = await Helpers().checkConnectivity(context);
            if (connectionResult) {
              Future.delayed(Duration.zero, () async {
                await initializeSettings(context);
              });
            }
          });
        }
      });

      Future.delayed(Duration.zero, () async {
        await Helpers().checkConnectivity(context);
      });
    });

    super.initState();
  }

  Future<void> initializeSettings(BuildContext context) async {
    ThemeProvier themeProvier =
        Provider.of<ThemeProvier>(context, listen: false);
    MobileAds.instance.initialize();
    final userData = UserData();
    final isDarkMode = await userData.getThemeMode();
    if (isDarkMode != null) {
      switch (isDarkMode) {
        case SystemTheme.light:
          themeProvier.brightness = Brightness.light;
          themeProvier.toggleTheme(ThemeMode.light);
          break;
        case SystemTheme.dark:
          themeProvier.brightness = Brightness.dark;
          themeProvier.toggleTheme(ThemeMode.dark);
          break;
        default:
          final brightness =
              PaintingBinding.instance.platformDispatcher.platformBrightness;
          themeProvier.brightness = brightness;
          themeProvier.toggleTheme(ThemeMode.system);
      }
    } else {
      final brightness =
          PaintingBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        themeProvier.toggleTheme(ThemeMode.system);
        themeProvier.brightness = Brightness.dark;
        await userData.setIsDarkMode(SystemTheme.system);
      } else {
        themeProvier.toggleTheme(ThemeMode.system);
        themeProvier.brightness = Brightness.light;
        await userData.setIsDarkMode(SystemTheme.system);
      }
    }
    Future.delayed(Duration.zero, () async {
      var connectionResult = await Helpers().checkConnectivity(context);
      final isUserOnborded = await UserData().isUserOnboarded();
      log('${isUserOnborded.toString()} is user onboarded');
      if (isUserOnborded != null ||
          isUserOnborded != false && connectionResult) {
        var result = await categoryProvider.fetchCategories();
        if (result != null) {
          init();
        } else {
          init();
        }
      }
    });
  }

  void init() async {
    final isUserOnborded = await UserData().isUserOnboarded();
    Timer(const Duration(milliseconds: 2000), () {
      if (isUserOnborded == null || isUserOnborded == false) {
        log('login true');
        Navigator.pushReplacement(
          context, // Current BuildContext
          MaterialPageRoute<void>(
            builder: (BuildContext context) => LoginScreen(
              arguments: LoginArguments(isOnboarding: true),
            ),
          ), // Named route for login screen
        );
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.landing);
      }
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FadeInWidget(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/splash_logo.svg',
                    width: deviceSize.width * 0.6,
                  ),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: deviceSize.width * 0.7,
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset('assets/images/vector_image1.svg'),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: SvgPicture.asset('assets/images/vector_image2.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
