

import 'dart:convert';
import 'package:Celes/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;


  late Map<String, String> _localizedValues;

  AppLocalization(this.locale);


  static AppLocalization? of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }


  Future loadJson() async {
    String jsonStringValues =
        await rootBundle.loadString('assets/languages/template.json');
    Map<String, dynamic> mappedJson = {};

    if (HiveUtils.getLanguage() == null ||
        HiveUtils.getLanguage()['data'] == null) {
      mappedJson = json.decode(jsonStringValues);
    } else {
      mappedJson = Map<String, dynamic>.from(HiveUtils.getLanguage()['data']);
    }
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslatedValues(String? key) {
    return _localizedValues[key!];
  }


  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}


class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();


  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.loadJson();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) {
    return true;
  }
}
