import 'package:Celes/app/app_theme.dart';
import 'package:Celes/app/app_routes.dart';
import 'package:Celes/utils/helper_utils.dart';
import 'package:Celes/utils/hive_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveUtils {
  ///private constructor
  HiveUtils._();

  static String getJWT() {
    return Hive.box(HiveKeys.userDetailsBox).get(HiveKeys.jwtToken);
  }

  static String? getUserId() {
    return Hive.box(HiveKeys.userDetailsBox).get("id").toString();
  }

  static String? getUserName() {
    return Hive.box(HiveKeys.userDetailsBox).get("name") as String?;
  }

  static AppTheme getCurrentTheme() {
    var current = Hive.box(HiveKeys.themeBox).get(HiveKeys.currentTheme);

    return current == "dark" ? AppTheme.dark : AppTheme.light;
  }

  static String? getCountryCode() {
    return Hive.box(HiveKeys.userDetailsBox).get("country_code");
  }

  static void setProfileNotCompleted() async {
    await Hive.box(HiveKeys.userDetailsBox)
        .put(HiveKeys.isProfileCompleted, false);
  }

  static dynamic setCurrentTheme(AppTheme theme) {
    String newTheme = theme == AppTheme.light ? "light" : "dark";

    Hive.box(HiveKeys.themeBox).put(HiveKeys.currentTheme, newTheme);
  }

  static Future<void> setUserData(Map data) async {
    await Hive.box(HiveKeys.userDetailsBox).putAll(data);
  }

  static Future<void> setJWT(String token) async {
    await Hive.box(HiveKeys.userDetailsBox).put(HiveKeys.jwtToken, token);
  }

  static Future<void> setUserIsAuthenticated(bool value) async {
    await Hive.box(HiveKeys.authBox).put(HiveKeys.isAuthenticated, value);
  }

  static Future<void> setUserIsNotNew() {
    return Hive.box(HiveKeys.authBox).put(HiveKeys.isUserFirstTime, false);
  }

  static Future<void> setUserSkip() {
    return Hive.box(HiveKeys.authBox).put(HiveKeys.isUserSkip, true);
  }

  static Future<bool> storeLanguage(
    dynamic data,
  ) async {
    Hive.box(HiveKeys.languageBox).put(HiveKeys.currentLanguageKey, data);
    return true;
  }

  static dynamic getLanguage() {
    return Hive.box(HiveKeys.languageBox).get(HiveKeys.currentLanguageKey);
  }

  @visibleForTesting
  static Future<void> setUserIsNew() {
    Hive.box(HiveKeys.authBox).put(HiveKeys.isAuthenticated, false);
    return Hive.box(HiveKeys.authBox).put(HiveKeys.isUserFirstTime, true);
  }

  static bool isUserAuthenticated() {
    return Hive.box(HiveKeys.authBox).get(HiveKeys.isAuthenticated) ?? false;
  }

  static bool isUserFirstTime() {
    return Hive.box(HiveKeys.authBox).get(HiveKeys.isUserFirstTime) ?? true;
  }

  static bool isUserSkip() {
    return Hive.box(HiveKeys.authBox).get(HiveKeys.isUserSkip) ?? false;
  }

  static void logoutUser(context,
      {required VoidCallback onLogout, bool? isRedirect}) async {
    await Hive.box(HiveKeys.userDetailsBox).clear();
    HiveUtils.setUserIsAuthenticated(false);

    onLogout.call();

    Future.delayed(
      Duration.zero,
      () {
        if (isRedirect ?? true) {
          HelperUtils.killPreviousPages(context, Routes.signIn, {});
        }
      },
    );
  }

  static String? getRefreshToken() {
    return Hive.box(HiveKeys.userDetailsBox).get(HiveKeys.refreshToken);
  }

  static Future<void> setRefreshToken(String token) async {
    await Hive.box(HiveKeys.userDetailsBox).put(HiveKeys.refreshToken, token);
  }

  static DateTime? getTokenExpiry() {
    final expiryString =
        Hive.box(HiveKeys.userDetailsBox).get(HiveKeys.tokenExpiry);
    if (expiryString == null) return null;
    return DateTime.tryParse(expiryString);
  }

  static Future<void> setTokenExpiry(DateTime expiryTime) async {
    await Hive.box(HiveKeys.userDetailsBox).put(
      HiveKeys.tokenExpiry,
      expiryTime.toIso8601String(),
    );
  }

  static Future<void> clearTokens() async {
    await Hive.box(HiveKeys.userDetailsBox).delete(HiveKeys.jwtToken);
    await Hive.box(HiveKeys.userDetailsBox).delete(HiveKeys.refreshToken);
    await Hive.box(HiveKeys.userDetailsBox).delete(HiveKeys.tokenExpiry);
  }

  static Future<void> clear() async {
    await Hive.box(HiveKeys.userDetailsBox).clear();
    await Hive.box(HiveKeys.historyBox).clear();
    await HiveUtils.setUserIsAuthenticated(false);
  }
}
