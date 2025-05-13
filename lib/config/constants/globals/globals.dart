import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<ScaffoldMessengerState> chatScaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

// final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<State> keyLoader = GlobalKey<State>();
final GlobalKey<State> apiLoader = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<State> apiLoader1 = GlobalKey<State>();

const String profileImagePlaceholder =
    "https://microbiology.ucr.edu/sites/default/files/styles/form_preview/public/blank-profile-pic.png";
