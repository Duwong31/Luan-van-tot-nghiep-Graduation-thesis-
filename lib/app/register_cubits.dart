import 'package:Celes/data/cubits/system/app_theme_cubit.dart';
import 'package:Celes/data/cubits/system/language_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

class RegisterCubits {
  List<SingleChildWidget> providers = [
    BlocProvider(create: (context) => AppThemeCubit()),
    BlocProvider(create: (context) => LanguageCubit()),
  ];
}
