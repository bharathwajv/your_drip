import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_core/components/Extension.dart';
import 'package:ui_core/components/animations/Loader.dart';
import 'package:ui_core/components/buttons/custom_text_button.dart';
import 'package:ui_core/core/base/base_hive.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/di.dart';

class ColorSchemeShowcase extends StatelessWidget {
  final List<String> _colorProperties = [
    'primary',
    'onPrimary',
    'primaryContainer',
    'onPrimaryContainer',
    'secondary',
    'onSecondary',
    'secondaryContainer',
    'onSecondaryContainer',
    'tertiary',
    'onTertiary',
    'tertiaryContainer',
    'onTertiaryContainer',
    'error',
    'errorContainer',
    'onError',
    'onErrorContainer',
    'background',
    'onBackground',
    'surface',
    'onSurface',
    'surfaceVariant',
    'onSurfaceVariant',
    'outline',
    'inverseSurface',
    'brightness',
  ];
  ColorSchemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SingleChildScrollView(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _colorProperties.length,
        itemBuilder: (context, index) {
          final propertyName = _colorProperties[index];
          final colorValue = _getColorValue(colorScheme, propertyName);
          final color = _getColor(colorScheme, propertyName);
          return Card(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$propertyName: $colorValue'),
                  const SizedBox(height: 8),
                  Container(width: 50, height: 50, color: color),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getColor(ColorScheme colorScheme, String propertyName) {
    switch (propertyName) {
      case 'primary':
        return colorScheme.primary;
      case 'onPrimary':
        return colorScheme.onPrimary;
      case 'primaryContainer':
        return colorScheme.primaryContainer;
      case 'onPrimaryContainer':
        return colorScheme.onPrimaryContainer;
      case 'secondary':
        return colorScheme.secondary;
      case 'onSecondary':
        return colorScheme.onSecondary;
      case 'secondaryContainer':
        return colorScheme.secondaryContainer;
      case 'onSecondaryContainer':
        return colorScheme.onSecondaryContainer;
      case 'tertiary':
        return colorScheme.tertiary;
      case 'onTertiary':
        return colorScheme.onTertiary;
      case 'tertiaryContainer':
        return colorScheme.tertiaryContainer;
      case 'onTertiaryContainer':
        return colorScheme.onTertiaryContainer;
      case 'error':
        return colorScheme.error;
      case 'errorContainer':
        return colorScheme.errorContainer;
      case 'onError':
        return colorScheme.onError;
      case 'onErrorContainer':
        return colorScheme.onErrorContainer;
      case 'background':
        return colorScheme.surface;
      case 'onBackground':
        return colorScheme.onSurface;
      case 'surface':
        return colorScheme.surface;
      case 'onSurface':
        return colorScheme.onSurface;
      case 'surfaceVariant':
        return colorScheme.surfaceContainerHighest;
      case 'onSurfaceVariant':
        return colorScheme.onSurfaceVariant;
      case 'outline':
        return colorScheme.outline;
      case 'inverseSurface':
        return colorScheme.inverseSurface;
      default:
        return Colors.transparent;
    }
  }

  String _getColorValue(ColorScheme colorScheme, String propertyName) {
    final Color color = _getColor(colorScheme, propertyName);
    return '#${color.value.toRadixString(16)}';
  }
}

class ColorSchemeShowcasePage extends StatelessWidget {
  const ColorSchemeShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Scheme Showcase')),
      body: ColorSchemeShowcase(),
    );
  }
}

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTextButton(
                buttonText: const Text("Start Loading"),
                onClick: () => Loader.startLoading(context),
                color: Theme.of(context).primaryColor,
              ),

              const SizedBox(height: 16),
              CustomTextButton(
                buttonText: const Text("Login"),
                onClick: () => context.pushNamed(Constants.route_loginPage),
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              CustomTextButton(
                buttonText: const Text("Go to App starting (clear cache)"),
                onClick: () => newMethod(context),
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 16),
              CustomTextButton(
                buttonText: const Text("Color Scheme Showcase"),
                onClick: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ColorSchemeShowcasePage(),
                  ),
                ),
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> newMethod(BuildContext context) async {
    getIt<HiveStorage>().clearAllBoxes();
    context.goNamed(Constants.route_home);
  }
}
