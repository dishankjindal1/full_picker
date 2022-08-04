import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:ahille/screen/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'generated/l10n.dart';
import 'screen/bloc/language_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, Locale>(builder: (context, lang) {
        return AdaptiveTheme(
          light: ThemeData(
            brightness: ThemeData.light().brightness,
            useMaterial3: true,
          ),
          dark: ThemeData(
            brightness: ThemeData.dark().brightness,
            useMaterial3: true,
          ),
          initial: savedThemeMode ?? AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => ResponsiveSizer(
            builder: (context, orientation, deviceType) {
              return ResponsiveSizer(
                builder: (context, orientation, screenType) {
                  return MaterialApp(
                    title: 'Ahille',
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    locale: lang,
                    theme: theme,
                    debugShowCheckedModeBanner: false,
                    darkTheme: darkTheme,
                    builder: (context, widget) => ResponsiveWrapper.builder(
                      ClampingScrollWrapper.builder(context, widget!),
                      defaultScale: true,
                      minWidth: 360,
                      defaultName: MOBILE,
                      breakpoints: [
                        const ResponsiveBreakpoint.resize(360),
                        const ResponsiveBreakpoint.resize(480, name: MOBILE),
                        const ResponsiveBreakpoint.resize(640, name: 'MOBILE_LARGE'),
                        const ResponsiveBreakpoint.resize(850, name: TABLET),
                        const ResponsiveBreakpoint.resize(1080, name: DESKTOP),
                      ],
                    ),
                    home: const Splash(),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
