import 'package:Celes/data/cubits/auth/auth_cubit.dart';
import 'package:Celes/data/cubits/auth/login_cubit.dart';
import 'package:Celes/data/cubits/home/home_cubit.dart';
import 'package:Celes/data/cubits/movie/movie_detail_cubit.dart';
import 'package:Celes/data/cubits/movie/movie_showtimes_cubit.dart';
import 'package:Celes/data/cubits/system/app_theme_cubit.dart';
import 'package:Celes/data/cubits/system/language_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

class RegisterCubits {
  List<SingleChildWidget> providers = [
    BlocProvider(create: (context) => AuthCubit()),
    BlocProvider(create: (context) => LoginCubit()),
    BlocProvider(create: (context) => HomeCubit()),
    BlocProvider(create: (context) => MovieDetailCubit()),
    BlocProvider(create: (context) => MovieShowtimesCubit()),
    BlocProvider(create: (context) => AppThemeCubit()),
    BlocProvider(create: (context) => LanguageCubit()),
  ];
}
