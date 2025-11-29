import 'package:Celes/ui/screens/auth/sign_in_screen.dart';
import 'package:Celes/ui/screens/auth/sign_up_screen.dart';
import 'package:Celes/ui/screens/main_activity.dart';
import 'package:Celes/ui/screens/welcome/choose_language_popup.dart';
import 'package:Celes/ui/screens/welcome/welcome_screen.dart';
import 'package:Celes/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const splash = 'splash';
  static const welcome = 'welcome';
  static const signUp = 'signUp';
  static const signIn = 'signIn';
  static const main = 'main';
  static const home = 'Home';
  static const chooseLanguage = 'chooseLanguage';

  static Route onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: ((context) => const SplashScreen()));
      case welcome:
        return CupertinoPageRoute(
            builder: ((context) => const WelcomeScreen()));
      case signUp:
        return CupertinoPageRoute(builder: ((context) => const SignUpScreen()));
      case signIn:
        return CupertinoPageRoute(builder: ((context) => const LoginScreen()));
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
