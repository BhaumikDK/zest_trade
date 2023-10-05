import 'package:flutter/material.dart';

import '../utils/base_colors.dart';

class ThemeProvider {
  static ThemeData light = ThemeData(
    fontFamily: 'Poppins',
    primaryColor: BaseColors.SKY_BLUE,
    brightness: Brightness.light,
    cardColor: Colors.white,
    focusColor: const Color(0xFFADC4C8),
    hintColor: const Color(0xFF52575C),
    backgroundColor: const Color(0xFFF4F7FC),
    // scaffoldBackgroundColor: BaseColors.SKY_BLUE,
    appBarTheme: const AppBarTheme(color: BaseColors.SKY_BLUE),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      foregroundColor: BaseColors.BLACK,
      textStyle: const TextStyle(color: BaseColors.BLACK),
    )),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    }),
    textTheme: const TextTheme(
      button: TextStyle(color: BaseColors.WHITE),
      headline1: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
      headline2: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      headline3: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      headline4: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      headline5: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      headline6: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
      caption: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
      subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
      bodyText2: TextStyle(fontSize: 12.0),
      bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
    ),
  );
}
