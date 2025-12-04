import 'dart:async';
import 'package:Celes/app/app_routes.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isTimerCompleted = false;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> startTimer() async {
    Timer(const Duration(seconds: 2), () {
      isTimerCompleted = true;
      if (mounted) setState(() {});
    });
  }

  void navigateCheck() {
    if (isTimerCompleted) {
      navigateToScreen();
    }
  }

  void navigateToScreen() async {
    // ✅ Check if user is authenticated
    final bool isAuthenticated = HiveUtils.isUserAuthenticated();

    // ✅ Check if user is first time (for onboarding)
    final bool isUserFirstTime = HiveUtils.isUserFirstTime();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (isAuthenticated) {
          // User is logged in, go to main screen
          Navigator.of(context).pushReplacementNamed(
            Routes.main,
            arguments: {
              'from': 'splash',
              'slug': null,
            },
          );
        } else if (isUserFirstTime) {
          // First time user, show welcome/onboarding
          Navigator.of(context).pushReplacementNamed(Routes.welcome);
        } else {
          // Returning user but not logged in, show welcome
          Navigator.of(context).pushReplacementNamed(Routes.welcome);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    navigateCheck();
    return SafeArea(
      top: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: context.color.territoryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: context.color.territoryColor,
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFF15151E),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/splash_logo.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 50),
                const CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
