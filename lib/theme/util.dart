import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,
    baseTextTheme,
  );
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}

FutureProvider<ThemeMode> themeProvider = FutureProvider((ref) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getBool("isDark") == null) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    await preferences.setBool("isDark", isDarkMode);
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
  return preferences.getBool("isDark") ?? false
      ? ThemeMode.dark
      : ThemeMode.light;
});
