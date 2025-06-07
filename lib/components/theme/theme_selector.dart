import 'package:flutter/material.dart';
import 'package:ui_core/components/CustomToggleSelection.dart';
import 'package:ui_core/components/Extension.dart';
import 'package:your_drip/components/theme/theme_controller.dart';
import 'package:your_drip/di.dart';

class ColorOption {
  final String name;
  final Color color;

  ColorOption(this.name, this.color);
}

class ColorOptionButton extends StatelessWidget {
  final ColorOption colorOption;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOptionButton({
    super.key,
    required this.colorOption,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.scalablePixel,
          vertical: 8.scalablePixel,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorOption.color.withOpacity(0.1)
              : context.colorScheme.surface,
          borderRadius: BorderRadius.circular(10.scalablePixel),
          border: Border.all(
            color: isSelected ? colorOption.color : context.colorScheme.outline,
            width: 1.scalablePixel,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 20.scalablePixel,
                  height: 20.scalablePixel,
                  decoration: BoxDecoration(
                    color: colorOption.color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 16.scalablePixel,
                    color: context.colorScheme.onPrimary,
                  ),
              ],
            ),
            SizedBox(width: 8.scalablePixel),
            Text(
              colorOption.name,
              style: context.textTheme.modifiedTextTheme(
                context.textTheme.bodyLarge!,
                isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FontOptionButton extends StatelessWidget {
  final String fontFamily;
  final bool isSelected;
  final VoidCallback onTap;

  const FontOptionButton({
    super.key,
    required this.fontFamily,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 51.scalablePixel,
        padding: EdgeInsets.symmetric(
          horizontal: 12.scalablePixel,
          vertical: 8.scalablePixel,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withOpacity(0.1)
              : context.colorScheme.surface,
          borderRadius: BorderRadius.circular(10.scalablePixel),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outline,
            width: 1.scalablePixel,
          ),
        ),
        child: Text(
          fontFamily,
          style: context.textTheme
              .modifiedTextTheme(
                context.textTheme.bodyLarge!,
                isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface,
              )
              .copyWith(fontFamily: fontFamily),
        ),
      ),
    );
  }
}

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  Color? selectedColor;
  String? selectedFont;

  final List<ColorOption> colorOptions = [
    ColorOption('Blue', Colors.blue),
    ColorOption('Green', Colors.green),
    ColorOption('Orange', Colors.orange),
    ColorOption('Red', Colors.red),
    ColorOption('Rose', Colors.pink),
    ColorOption('Slate', Colors.blueGrey),
    ColorOption('Violet', Colors.purple),
    ColorOption('Yellow', Colors.yellow),
    ColorOption('Teal', Colors.teal),
    ColorOption('Cyan', Colors.cyan),
    ColorOption('Indigo', Colors.indigo),
  ];
  int defaultSelectedIndex = 0;
  Key toggleKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.scalablePixel),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tint Twist',
            style: context.textTheme.modifiedTextTheme(
              context.textTheme.headlineMedium!,
              context.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16.scalablePixel),
          CustomToggleSelection(
            key: toggleKey,
            defaultSelectedIndex: defaultSelectedIndex,
            height: 23.scalablePixel,
            borderRadius: 15.scalablePixel,
            options: const ['TonalSpot', 'Salad', 'Monochrome'],
            onSelected: (selectedOption) {
              if (selectedOption == 'TonalSpot') {
                getIt<ThemeController>().setThemeVariant(
                  DynamicSchemeVariant.tonalSpot,
                );
              } else if (selectedOption == 'Salad') {
                getIt<ThemeController>().setThemeVariant(
                  DynamicSchemeVariant.fruitSalad,
                );
              } else if (selectedOption == 'Monochrome') {
                getIt<ThemeController>().setThemeVariant(
                  DynamicSchemeVariant.monochrome,
                );
              }
            },
          ),
          SizedBox(height: 16.scalablePixel),
          Wrap(
            spacing: 12.scalablePixel,
            runSpacing: 12.scalablePixel,
            children: colorOptions.map((option) {
              return ColorOptionButton(
                colorOption: option,
                isSelected: option.color == selectedColor,
                onTap: () => onColorSelected(option.color),
              );
            }).toList(),
          ),
          SizedBox(height: 24.scalablePixel),
          Text(
            'Find Your Font',
            style: context.textTheme.modifiedTextTheme(
              context.textTheme.headlineMedium!,
              context.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16.scalablePixel),
          Wrap(
            spacing: 12.scalablePixel,
            runSpacing: 12.scalablePixel,
            children: ThemeController.fontFamilies.map((font) {
              return FontOptionButton(
                fontFamily: font,
                isSelected: font == selectedFont,
                onTap: () => onFontSelected(font),
              );
            }).toList(),
          ),
          SizedBox(height: 5.scalablePixel),
        ],
      ),
    );
  }

  void onColorSelected(Color color) {
    setState(() {
      selectedColor = color;
      defaultSelectedIndex = 0;
      toggleKey = UniqueKey();
    });
    getIt<ThemeController>().setThemeColor(color);
  }

  void onFontSelected(String fontFamily) {
    setState(() {
      selectedFont = fontFamily;
    });
    getIt<ThemeController>().setFontFamily(fontFamily);
  }
}
