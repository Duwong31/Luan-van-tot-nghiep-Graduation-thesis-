import 'package:Celes/ui/screens/auth/sign_in_screen.dart';
import 'package:Celes/ui/screens/main_activity.dart';
import 'package:Celes/ui/screens/onboarding/choose_language_popup.dart';
import 'package:Celes/ui/screens/onboarding/onboarding_screen.dart';
import 'package:Celes/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const main = 'main';
  static const home = 'Home';
  static const chooseLanguage = 'chooseLanguage';

  static Route onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
            builder: ((context) => const SplashScreen()));
      case onboarding:
        return CupertinoPageRoute(
            builder: ((context) => const OnboardingScreen()));
      case login:
        return CupertinoPageRoute(
            builder: ((context) => const SignInScreen()));
      case main:
        return MainActivity.route(routeSettings);
      case chooseLanguage:
        return CupertinoPageRoute(
            builder: ((context) => const ChooseLanguagePopup()));
      default:
        return CupertinoPageRoute(builder: (context) => const Scaffold());
    }
  }
}
