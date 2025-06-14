import 'package:flutter/material.dart';
import 'package:ui_core/components/Extension.dart';
import 'package:your_drip/components/loader/loader.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      body: SafeArea(child: Center(child: ShapesPreview())),
    );
  }
}
