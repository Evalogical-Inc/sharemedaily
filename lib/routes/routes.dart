import 'package:flutter/material.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/about_us/about_us.dart';
import 'package:quotify/screens/add_reminder/add_reminder_screen.dart';
import 'package:quotify/screens/category/cartegory_screen.dart';
import 'package:quotify/screens/favorite/favorite_screen.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/feature/feature_screen_edit.dart';
import 'package:quotify/screens/home/home_screen.dart';
import 'package:quotify/screens/landing/landing_screen.dart';
import 'package:quotify/screens/login/login.dart';
import 'package:quotify/screens/onboard/onboard_end_screen.dart';
import 'package:quotify/screens/onboard/onboard_schedule_screen.dart';
import 'package:quotify/screens/onboard/onboard_select_category_screen.dart';
import 'package:quotify/screens/privacy_policy/privacy_policy.dart';
import 'package:quotify/screens/profile/profile_edit_screen.dart';
import 'package:quotify/screens/profile/profile_screen.dart';
import 'package:quotify/screens/quotes/quote_listing_screen.dart';
import 'package:quotify/screens/setting/settings_screen.dart';
import 'package:quotify/screens/splash_screen/splash_screen.dart';
import 'package:quotify/screens/theme/theme_screen.dart';
import 'package:quotify/screens/widget_guide/widget_guide.dart';
import 'package:quotify/widgets/custom_page_route.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(
            arguments: LoginArguments(isOnboarding: false),
          ),
          settings: settings,
        );
      case AppRoutes.home:
        return CustomPageRoute(
          child: const HomeScreen(),
          settings: settings,
        );
      case AppRoutes.onboardCategory:
        return CustomPageRoute(
          child: const OnboardSelectCategoryScreen(),
          settings: settings,
        );
      case AppRoutes.onboardSchedule:
        return CustomPageRoute(
          child: const OnboardScheduleScreen(),
          settings: settings,
        );
      case AppRoutes.category:
        return CustomPageRoute(
          direction: AxisDirection.up,
          child: const CategoryScreen(),
          settings: settings,
        );
      case AppRoutes.onboardEnd:
        return CustomPageRoute(
          child: const OnboardEndScreen(),
          settings: settings,
        );
      case AppRoutes.landing:
        return MaterialPageRoute(
          builder: (context) => const LandingScreen(),
          settings: settings,
        );
      case AppRoutes.feature:
        return MaterialPageRoute(
          builder: (context) => const FeatureScreen(),
          settings: settings,
        );
      case AppRoutes.featureEdit:
        return MaterialPageRoute(
          builder: (context) => const FeatureScreenEdit(),
          settings: settings,
        );
      case AppRoutes.addReminder:
        return CustomPageRoute(
          child: const AddReminderScreen(),
          settings: settings,
        );
      case AppRoutes.favorite:
        return MaterialPageRoute(
          builder: (context) => const FavoriteScreen(),
          settings: settings,
        );
      case AppRoutes.profile:
        return CustomPageRoute(
          child: ProfileScreen(),
          direction: AxisDirection.right,
          settings: settings,
        );
      case AppRoutes.profileEdit:
        return CustomPageRoute(
          child: const ProfileEdit(),
          direction: AxisDirection.right,
          settings: settings,
        );
      case AppRoutes.quoteListing:
        return CustomPageRoute(
          child: const QuoteListingScreen(),
          settings: settings,
        );
      case AppRoutes.settings:
        return CustomPageRoute(
          child: const SettingScreen(),
          settings: settings,
        );
      case AppRoutes.theme:
        return CustomPageRoute(
          child: const ThemeScreen(),
          settings: settings,
        );
      case AppRoutes.privacyPolicy:
        return CustomPageRoute(
          child: const PrivacyPolicy(),
          settings: settings,
        );
      case AppRoutes.widgetGuide:
        return CustomPageRoute(
          child: WidgetGuidePage(),
          settings: settings,
        );
      case AppRoutes.aboutUs:
        return CustomPageRoute(
          child: const AboutUs(),
          settings: settings,
        );
      // case AppRoutes.quotesEdit:
      //   return CustomPageRoute(
      //     child: QuoteEdit(
      //       arguments: QuoteArguments(imagePath: '', quote: '',imageAuthor:'', tagName: ''),
      //     ),
      //     settings: settings,
      //   );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Error route'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
