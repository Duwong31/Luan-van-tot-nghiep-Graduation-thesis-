import 'dart:async';
import 'package:Celes/app/app_routes.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isTimerCompleted = false;

  @override
  void initState() {
    //locationPermission();
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> startTimer() async {
    Timer(const Duration(seconds: 1), () {
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
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.main, arguments: {
          'from': "main",
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    navigateCheck();
    return SafeArea(
        top: false,
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: context.color.territoryColor,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: context.color.territoryColor,
          ),
          child: Scaffold(
            backgroundColor: context.color.backgroundColor,
            body: Center(
              child: Text('Splash Screen'),
          ),
        ),
      ),
    );
  }
}
