import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const login = 'login';
  static Route onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      default:
        return CupertinoPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
