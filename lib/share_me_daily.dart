import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/globals/route_observer.dart';
import 'package:quotify/config/constants/system_theme.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/daily_quotes_provider.dart';
import 'package:quotify/provider/editor_provider.dart';
import 'package:quotify/provider/login_provider.dart';
import 'package:quotify/provider/onbord_schedule_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/search_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/routes/routes.dart';
import 'package:quotify/theme/app_theme.dart';
import 'package:quotify/utilities/user_util.dart';
import 'package:quotify/widgets/custom_editor/story_maker_provider.dart';
// import 'package:quotify/widgets/appinio_swiper/swiper_provider.dart';

class ShareMeDaily extends StatefulWidget {
  const ShareMeDaily({super.key});

  @override
  State<ShareMeDaily> createState() => _ShareMeDailyState();
}

class _ShareMeDailyState extends State<ShareMeDaily> {
  @override
  void initState() {
    super.initState();

    PlatformDispatcher.instance.onPlatformBrightnessChanged = () async {
      final newBrightness = PlatformDispatcher.instance.platformBrightness;
      final themeData = Provider.of<ThemeProvier>(context, listen: false);
      final userData = UserData();

      if (themeData.themeMode == ThemeMode.system &&
          themeData.brightness != newBrightness) {
        // Update provider brightness
        themeData.brightness = newBrightness;
        // Persist user's theme preference
        await userData.setIsDarkMode(
          newBrightness == Brightness.dark
              ? SystemTheme.dark
              : SystemTheme.light,
        );
      }
    };
  }

  @override
  void dispose() {
    // Important: reset the listener to avoid memory leaks
    PlatformDispatcher.instance.onPlatformBrightnessChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvier>(builder: (context, data, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldKey,
        themeMode: data.themeMode,
        navigatorObservers: [routeObserver],
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        initialRoute: '/',
      );
    });
  }
}
