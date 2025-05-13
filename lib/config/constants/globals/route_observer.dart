import 'dart:developer';

import 'package:flutter/material.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  String? previousRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute is PageRoute) {
      previousRouteName = previousRoute.settings.name;
      log("Previous Route: $previousRouteName");
    }
  }
}

final RouteObserver<PageRoute> routeObserver = MyRouteObserver();
