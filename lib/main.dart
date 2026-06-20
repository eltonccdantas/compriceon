import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants.dart';
import 'core/localization.dart';
import 'pages/price_comparator_page.dart';

void main() {
  runApp(const CompriceonApp());
}

class CompriceonApp extends StatefulWidget {
  const CompriceonApp({super.key});

  @override
  State<CompriceonApp> createState() => _CompriceonAppState();
}

class _CompriceonAppState extends State<CompriceonApp> {
  AppLocale _locale = AppLocale.ptBR;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      locale: _locale,
      setLocale: (newLocale) => setState(() => _locale = newLocale),
      themeMode: _themeMode,
      setThemeMode: (newMode) => setState(() => _themeMode = newMode),
      child: MaterialApp(
        title: 'Compriceon',
        debugShowCheckedModeBanner: false,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        themeMode: _themeMode,
        home: const PriceComparatorPage(),
      ),
    );
  }

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kBlue,
        brightness: brightness,
      ),
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
    );
  }
}
