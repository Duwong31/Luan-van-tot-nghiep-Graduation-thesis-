// ignore_for_file: depend_on_referenced_packages

import 'package:Celes/app/app_theme.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:bloc/bloc.dart';

class AppThemeCubit extends Cubit<ThemeState> {
  AppThemeCubit() : super(ThemeState(AppTheme.light));
// HiveUtils.getCurrentTheme()
  void changeTheme(AppTheme appTheme) {
    HiveUtils.setCurrentTheme(appTheme);
    emit(ThemeState(appTheme));
  }

  void toggleTheme() {
    if (state.appTheme == AppTheme.dark) {
      HiveUtils.setCurrentTheme(AppTheme.light);

      emit(ThemeState(AppTheme.light));
    } else {
      HiveUtils.setCurrentTheme(AppTheme.dark);

      emit(ThemeState(AppTheme.dark));
    }
  }

  bool isDarkMode() {
    return state.appTheme == AppTheme.dark;
  }
}

class ThemeState {
  final AppTheme appTheme;

  ThemeState(this.appTheme);
}
