import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff414dae),
      surfaceTint: Color(0xff4955b6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5a66c8),
      onPrimaryContainer: Color(0xfff4f2ff),
      secondary: Color(0xff575c83),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffced1ff),
      onSecondaryContainer: Color(0xff545980),
      tertiary: Color(0xff863783),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa2509d),
      onTertiaryContainer: Color(0xffffeff8),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff1b1b21),
      onSurfaceVariant: Color(0xff454652),
      outline: Color(0xff767683),
      outlineVariant: Color(0xffc6c5d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303037),
      inversePrimary: Color(0xffbcc2ff),
      primaryFixed: Color(0xffdfe0ff),
      onPrimaryFixed: Color(0xff000a63),
      primaryFixedDim: Color(0xffbcc2ff),
      onPrimaryFixedVariant: Color(0xff303c9d),
      secondaryFixed: Color(0xffdfe0ff),
      onSecondaryFixed: Color(0xff14183b),
      secondaryFixedDim: Color(0xffc0c3f0),
      onSecondaryFixedVariant: Color(0xff404469),
      tertiaryFixed: Color(0xffffd7f6),
      onTertiaryFixed: Color(0xff380039),
      tertiaryFixedDim: Color(0xffffaaf5),
      onTertiaryFixedVariant: Color(0xff732671),
      surfaceDim: Color(0xffdbd9e2),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2fb),
      surfaceContainer: Color(0xffefedf6),
      surfaceContainerHigh: Color(0xffe9e7f0),
      surfaceContainerHighest: Color(0xffe4e1ea),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1c298c),
      surfaceTint: Color(0xff4955b6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5864c6),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2f3358),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff666a92),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5f125f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa04e9b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff101117),
      onSurfaceVariant: Color(0xff353541),
      outline: Color(0xff51515e),
      outlineVariant: Color(0xff6c6c79),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303037),
      inversePrimary: Color(0xffbcc2ff),
      primaryFixed: Color(0xff5864c6),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3f4bac),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff666a92),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4e5278),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffa04e9b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff843581),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc7c5ce),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2fb),
      surfaceContainer: Color(0xffe9e7f0),
      surfaceContainerHigh: Color(0xffdedce4),
      surfaceContainerHighest: Color(0xffd2d0d9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0e1c82),
      surfaceTint: Color(0xff4955b6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff323e9f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff25294d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff42466c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff530254),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff762974),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2a2b37),
      outlineVariant: Color(0xff484855),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303037),
      inversePrimary: Color(0xffbcc2ff),
      primaryFixed: Color(0xff323e9f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff182488),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff42466c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2b3054),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff762974),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5b0c5b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b8c0),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2eff8),
      surfaceContainer: Color(0xffe4e1ea),
      surfaceContainerHigh: Color(0xffd5d3dc),
      surfaceContainerHighest: Color(0xffc7c5ce),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbcc2ff),
      surfaceTint: Color(0xffbcc2ff),
      onPrimary: Color(0xff152286),
      primaryContainer: Color(0xff5a66c8),
      onPrimaryContainer: Color(0xfff4f2ff),
      secondary: Color(0xffc0c3f0),
      onSecondary: Color(0xff292d52),
      secondaryContainer: Color(0xff42466c),
      onSecondaryContainer: Color(0xffb2b5e1),
      tertiary: Color(0xffffaaf5),
      onTertiary: Color(0xff580859),
      tertiaryContainer: Color(0xffa2509d),
      onTertiaryContainer: Color(0xffffeff8),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121319),
      onSurface: Color(0xffe4e1ea),
      onSurfaceVariant: Color(0xffc6c5d4),
      outline: Color(0xff908f9e),
      outlineVariant: Color(0xff454652),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1ea),
      inversePrimary: Color(0xff4955b6),
      primaryFixed: Color(0xffdfe0ff),
      onPrimaryFixed: Color(0xff000a63),
      primaryFixedDim: Color(0xffbcc2ff),
      onPrimaryFixedVariant: Color(0xff303c9d),
      secondaryFixed: Color(0xffdfe0ff),
      onSecondaryFixed: Color(0xff14183b),
      secondaryFixedDim: Color(0xffc0c3f0),
      onSecondaryFixedVariant: Color(0xff404469),
      tertiaryFixed: Color(0xffffd7f6),
      onTertiaryFixed: Color(0xff380039),
      tertiaryFixedDim: Color(0xffffaaf5),
      onTertiaryFixedVariant: Color(0xff732671),
      surfaceDim: Color(0xff121319),
      surfaceBright: Color(0xff39393f),
      surfaceContainerLowest: Color(0xff0d0e14),
      surfaceContainerLow: Color(0xff1b1b21),
      surfaceContainer: Color(0xff1f1f25),
      surfaceContainerHigh: Color(0xff292930),
      surfaceContainerHighest: Color(0xff34343b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd8daff),
      surfaceTint: Color(0xffbcc2ff),
      onPrimary: Color(0xff02127c),
      primaryContainer: Color(0xff7c88ed),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd8daff),
      onSecondary: Color(0xff1e2346),
      secondaryContainer: Color(0xff8a8eb8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffcdf5),
      onTertiary: Color(0xff49004a),
      tertiaryContainer: Color(0xffc872c1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdcdbea),
      outline: Color(0xffb1b0bf),
      outlineVariant: Color(0xff8f8f9d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1ea),
      inversePrimary: Color(0xff313d9e),
      primaryFixed: Color(0xffdfe0ff),
      onPrimaryFixed: Color(0xff000547),
      primaryFixedDim: Color(0xffbcc2ff),
      onPrimaryFixedVariant: Color(0xff1c298c),
      secondaryFixed: Color(0xffdfe0ff),
      onSecondaryFixed: Color(0xff090d31),
      secondaryFixedDim: Color(0xffc0c3f0),
      onSecondaryFixedVariant: Color(0xff2f3358),
      tertiaryFixed: Color(0xffffd7f6),
      onTertiaryFixed: Color(0xff260027),
      tertiaryFixedDim: Color(0xffffaaf5),
      onTertiaryFixedVariant: Color(0xff5f125f),
      surfaceDim: Color(0xff121319),
      surfaceBright: Color(0xff44444b),
      surfaceContainerLowest: Color(0xff07070c),
      surfaceContainerLow: Color(0xff1d1d23),
      surfaceContainer: Color(0xff27272e),
      surfaceContainerHigh: Color(0xff323239),
      surfaceContainerHighest: Color(0xff3d3d44),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0eeff),
      surfaceTint: Color(0xffbcc2ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffb8beff),
      onPrimaryContainer: Color(0xff000337),
      secondary: Color(0xfff0eeff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbcbfec),
      onSecondaryContainer: Color(0xff04072b),
      tertiary: Color(0xffffeaf8),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffa3f5),
      onTertiaryContainer: Color(0xff1c001d),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff121319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff0eefe),
      outlineVariant: Color(0xffc2c1d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1ea),
      inversePrimary: Color(0xff313d9e),
      primaryFixed: Color(0xffdfe0ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffbcc2ff),
      onPrimaryFixedVariant: Color(0xff000547),
      secondaryFixed: Color(0xffdfe0ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc0c3f0),
      onSecondaryFixedVariant: Color(0xff090d31),
      tertiaryFixed: Color(0xffffd7f6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffaaf5),
      onTertiaryFixedVariant: Color(0xff260027),
      surfaceDim: Color(0xff121319),
      surfaceBright: Color(0xff504f57),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f25),
      surfaceContainer: Color(0xff303037),
      surfaceContainerHigh: Color(0xff3b3b42),
      surfaceContainerHighest: Color(0xff46464d),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
