import 'package:Celes/ui/screens/auth/forgot_password_screen.dart';
import 'package:Celes/ui/screens/auth/reset_password_screen.dart';
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
  static const forgotPassword = 'forgotPassword';
  static const resetPassword = 'resetPassword';
  static const main = 'main';
  static const home = 'Home';
  static const chooseLanguage = 'chooseLanguage';
  static const searchScreenRoute = '/searchScreenRoute';

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
      case forgotPassword:
        return CupertinoPageRoute(
            builder: ((context) => const ForgotPasswordScreen()));
      case resetPassword:
        Map arguments = routeSettings.arguments as Map;
        return CupertinoPageRoute(
            builder: ((context) => ResetPasswordScreen(
                  email: arguments['email'] as String,
                  resetToken: arguments['resetToken'] as String,
                )));
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
