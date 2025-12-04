import 'package:Celes/app/app_routes.dart';
import 'package:Celes/app/app_theme.dart';
import 'package:Celes/data/cubits/system/app_theme_cubit.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/extensions/lib/translate.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class UiUtils {
  static SvgPicture getSvg(String path,
      {Color? color, BoxFit? fit, double? width, double? height}) {
    return SvgPicture.asset(
      path,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,
    );
  }
  static Color getAdaptiveTextColor(Color color) {
    int d = 0;

    double luminance =
        (0.299 * color.r + 0.587 * color.g + 0.114 * color.b) / 255;
    d = luminance > 0.5 ? 0 : 255;

    return Color.fromARGB(color.a.toInt(), d, d, d);
  }

  static void checkUser(
      {required Function() onNotGuest, required BuildContext context}) {
    if (!HiveUtils.isUserAuthenticated()) {
      _loginBox(context);
    } else {
      onNotGuest.call();
    }
  }

  static void _loginBox(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: false,
      backgroundColor: context.color.primaryColor.withValues(alpha: 0.9),
      enableDrag: false,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(
              30, 30, 30, MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "loginIsRequiredForAccessingThisFeatures".translate(context),
                fontSize: context.font.larger,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomText("tapOnLoginToAuthorize".translate(context),
                  fontSize: context.font.small),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                elevation: 0,
                color: context.color.territoryColor,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.signUp,
                      arguments: {"popToCurrent": true});
                },
                child: CustomText(
                  "loginNow".translate(context),
                  color: context.color.buttonColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static SystemUiOverlayStyle getSystemUiOverlayStyle(
      {required BuildContext context,
      required Color statusBarColor,
      Color? navigationBarColor}) {
    bool isDarkMode =
        context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark;
    Brightness iconBrightness = isDarkMode ? Brightness.light : Brightness.dark;
    return SystemUiOverlayStyle(
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: iconBrightness,
        systemNavigationBarColor:
            navigationBarColor ?? context.color.secondaryColor,
        statusBarColor: statusBarColor,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: iconBrightness);
  }
}

///Format string
extension FormatAmount on String {
  String formatPercentage() {
    return "${toString()} %";
  }

  String formatId() {
    return " # ${toString()} "; // \u{20B9}"; //currencySymbol
  }

  String firstUpperCase() {
    String upperCase = "";
    var suffix = "";
    if (isNotEmpty) {
      upperCase = this[0].toUpperCase();
      suffix = substring(1, length);
    }
    return (upperCase + suffix);
  }
}

//scroll controller extenstion

extension ScrollEndListen on ScrollController {
  ///It will check if scroll is at the bottom or not
  bool isEndReached() {
    return offset >= position.maxScrollExtent;
  }
}

class RemoveGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

extension ColorUtils on Color {
  int toInt() {
    final alpha = (a * 255).toInt();
    final red = (r * 255).toInt();
    final green = (g * 255).toInt();
    final blue = (b * 255).toInt();
    // Combine the components into a single int using bit shifting
    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }
}
