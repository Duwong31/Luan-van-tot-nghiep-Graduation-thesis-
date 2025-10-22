import 'package:Celes/ui/screens/main_activity.dart';
import 'package:Celes/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const main = 'main';
  static const home = 'Home';

  static Route onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
            builder: ((context) => const SplashScreen()));
      // case onboarding:
      //   return CupertinoPageRoute(
      //       builder: ((context) => const OnboardingScreen()));
      case main:
        return MainActivity.route(routeSettings);
      default:
        return CupertinoPageRoute(builder: (context) => const Scaffold());
    }
  }
}
