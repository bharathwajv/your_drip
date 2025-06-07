import 'package:flutter/material.dart';

//42985B

class AppColors {
  /// Light theme colors *
  static ColorScheme chai_theme_light = ColorScheme(
    primary: HexColor("#ff42985B"),
    onPrimary: HexColor("#ffffffff"),
    primaryContainer: HexColor("#ffadf3b9"),
    onPrimaryContainer: HexColor("#ff00210b"),
    surfaceTint: HexColor("#ffEDF9F2"),
    surfaceContainerHighest: HexColor("#ffEDF9F2"),
    secondary: HexColor("#ff506352"),
    onSecondary: HexColor("#ffffffff"),
    secondaryContainer: HexColor("#ffd3e8d2"),
    onSecondaryContainer: HexColor("#ff0e1f12"),
    tertiary: HexColor("#ff867cff"),
    onTertiary: HexColor("#ffffffff"),
    tertiaryContainer: HexColor("#ffF2F1FF"),
    onTertiaryContainer: HexColor("#ff001f25"),
    error: HexColor("#ffba1a1a"),
    errorContainer: HexColor("#ffffdad6"),
    onError: HexColor("#ffffffff"),
    onErrorContainer: HexColor("#ff410002"),
    surface: HexColor("#ffffffff"),
    onSurface: HexColor("#ff191c19"),
    onSurfaceVariant: HexColor("#ff414941"),
    outline: HexColor("#ff717970"),
    inverseSurface: HexColor("#ff2e312e"),
    brightness: Brightness.light,
  );

  /// Dark theme colors *
  static ColorScheme chai_theme_dark = ColorScheme(
    primary: HexColor("#ff0a6d35"),
    onPrimary: HexColor("#ffffffff"),
    primaryContainer: HexColor("#ffadf3b9"),
    onPrimaryContainer: HexColor("#ff00210b"),
    secondary: HexColor("#ff506352"),
    onSecondary: HexColor("#ffffffff"),
    secondaryContainer: HexColor("#ffd3e8d2"),
    onSecondaryContainer: HexColor("#ff0e1f12"),
    tertiary: HexColor("#ff3a656e"),
    onTertiary: HexColor("#ffffffff"),
    tertiaryContainer: HexColor("#ffbdeaf5"),
    onTertiaryContainer: HexColor("#ff001f25"),
    error: HexColor("#ffba1a1a"),
    errorContainer: HexColor("#ffffdad6"),
    onError: HexColor("#ffffffff"),
    onErrorContainer: HexColor("#ff410002"),
    surface: HexColor("#ff191c19"),
    onSurface: HexColor("#ffffffff"),
    onSurfaceVariant: HexColor("#ffdde5da"),
    outline: HexColor("#ff717970"),
    inverseSurface: HexColor("#ff2e312e"),
    brightness: Brightness.dark,
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }
}
