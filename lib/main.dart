import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/globals/ad_manager.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/daily_quotes_provider.dart';
import 'package:quotify/provider/editor_provider.dart';
import 'package:quotify/provider/login_provider.dart';
import 'package:quotify/provider/onbord_schedule_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/search_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/share_me_daily.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quotify/widgets/custom_editor/story_maker_provider.dart';

void main() async {
  await init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AdManager()..loadAd(), // Load ad when app starts
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeProvier(),
      ),
      ChangeNotifierProvider(
        create: (context) => OnboardScheduleProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => EditProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => DailyQuotesProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CategoryProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => QuoteListingProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => LoginProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => StoryMakerProvider(),
      ),
    ],
    child: ShareMeDaily(),
  ));
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");
}
