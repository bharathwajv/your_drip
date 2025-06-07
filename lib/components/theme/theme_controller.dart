import 'package:flutter/material.dart';
import 'package:ui_core/constant/text_themes.dart';
import 'package:your_drip/constant/app_colors.dart';

class ThemeController {
  static final ThemeController _instance = ThemeController._internal();

  // Set of predefined Flutter colors
  static List<Color> predefinedColors = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.grey,
    Colors.white,
  ];

  static final fontFamilies = ['Jost', 'Oddval'];

  final ValueNotifier<ThemeData> _currentTheme = ValueNotifier(
    ThemeData(
      fontFamily: 'Jost',
      textTheme: CoreText.appTextTheme,
      colorScheme: AppColors.chai_theme_light,
    ),
  );
  factory ThemeController() {
    return _instance;
  }

  ThemeController._internal();

  ValueNotifier<ThemeData> get currentTheme => _currentTheme;

  void randomizeTheme() {
    final randomColor = (predefinedColors..shuffle()).first;
    final randomFontFamily = (fontFamilies..shuffle()).first;

    _currentTheme.value = ThemeData(
      fontFamily: randomFontFamily,
      textTheme: CoreText.appTextTheme,
      colorScheme: ColorScheme.fromSeed(seedColor: randomColor),
    );
  }

  void setFontFamily(String fontFamily) {
    _currentTheme.value = _currentTheme.value.copyWith(
      textTheme: CoreText.appTextTheme.apply(fontFamily: fontFamily),
    );
  }

  void setThemeColor(Color color) {
    _currentTheme.value = _currentTheme.value.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: color),
    );
  }

  void setThemeVariant(DynamicSchemeVariant variant) {
    _currentTheme.value = _currentTheme.value.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _currentTheme.value.colorScheme.primary,
        dynamicSchemeVariant: variant,
      ),
    );
  }
}
