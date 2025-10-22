import 'package:Celes/app/app.dart';
import 'package:Celes/app/app_localization.dart';
import 'package:Celes/app/app_routes.dart';
import 'package:Celes/app/app_theme.dart';
import 'package:Celes/app/register_cubits.dart';
import 'package:Celes/data/cubits/system/app_theme_cubit.dart';
import 'package:Celes/data/cubits/system/language_cubit.dart';
import 'package:Celes/utils/constant.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => initApp();

class EntryPoint extends StatefulWidget {
  const EntryPoint({
    super.key,
  });

  @override
  EntryPointState createState() => EntryPointState();
}

class EntryPointState extends State<EntryPoint> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: RegisterCubits().providers,
      child: Builder(builder: (BuildContext context) {
        return const App();
      }));
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    context.read<LanguageCubit>().loadCurrentLanguage();

    AppTheme currentTheme = HiveUtils.getCurrentTheme();

    context.read<AppThemeCubit>().changeTheme(currentTheme);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme currentTheme = context.watch<AppThemeCubit>().state.appTheme;
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return MaterialApp(
          initialRoute: Routes.splash,
          navigatorKey: Constant.navigatorKey,
          title: Constant.appName,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRouted,
          theme: appThemeData[currentTheme],
          builder: (context, child) {
            TextDirection direction = TextDirection.ltr;

            if (languageState is LanguageLoader) {
              direction = languageState.language['rtl']
                  ? TextDirection.rtl
                  : TextDirection.ltr;
            }
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: Directionality(
                textDirection: direction,
                child: DevicePreview(
                  enabled: false,
                  builder: (context) {
                    return child!;
                  },
                ),
              ),
            );
          },
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: loadLocalLanguageIfFail(languageState),
        );
      },
    );
  }

  dynamic loadLocalLanguageIfFail(LanguageState state) {
    if ((state is LanguageLoader)) {
      return Locale(state.language['code']);
    } else if (state is LanguageLoadFail) {
      return const Locale("en");
    }
  }
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
