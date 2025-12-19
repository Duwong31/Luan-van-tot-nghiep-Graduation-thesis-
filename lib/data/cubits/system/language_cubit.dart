import 'package:Celes/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final Locale locale;

  LanguageLoaded(this.locale);
}

// Cubit
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  /// Load ngôn ngữ hiện tại từ Hive
  void loadCurrentLanguage() {
    final languageData = HiveUtils.getLanguage();

    if (languageData != null && languageData['code'] != null) {
      final locale = Locale(languageData['code']);
      emit(LanguageLoaded(locale));
    } else {
      // Mặc định là tiếng Việt
      emit(LanguageLoaded(const Locale('vi')));
    }
  }

  /// Đổi ngôn ngữ
  void changeLanguage(Locale locale) {
    // Lưu vào Hive
    HiveUtils.storeLanguage({
      'code': locale.languageCode,
      'name': locale.languageCode == 'vi' ? 'Tiếng Việt' : 'English',
      'rtl': false, // Vietnamese và English đều là LTR
    });

    emit(LanguageLoaded(locale));
  }

  /// Toggle giữa tiếng Việt và tiếng Anh
  void toggleLanguage() {
    if (state is LanguageLoaded) {
      final currentLocale = (state as LanguageLoaded).locale;
      final newLocale = currentLocale.languageCode == 'vi'
          ? const Locale('en')
          : const Locale('vi');
      changeLanguage(newLocale);
    }
  }

  /// Lấy locale hiện tại
  Locale getCurrentLocale() {
    if (state is LanguageLoaded) {
      return (state as LanguageLoaded).locale;
    }
    return const Locale('vi'); // Default
  }

  /// Lấy language code hiện tại
  String currentLanguageCode() {
    return getCurrentLocale().languageCode;
  }
}
