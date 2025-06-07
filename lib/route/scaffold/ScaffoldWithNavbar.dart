import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_core/components/animations/Loader.dart';
import 'package:ui_core/components/buttons/fab_button.dart';
import 'package:your_drip/components/theme/theme_controller.dart';
import 'package:your_drip/core/FeatureFlag.dart';
import 'package:your_drip/di.dart';

class ScaffoldWithNavbar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  final featureFlagService = getIt<IFeatureFlagService>();
  ScaffoldWithNavbar(this.navigationShell, {super.key});

  @override
  Widget build(BuildContext context) {
    return Loader(
      context: context,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // bottomNavigationBar:
        //     CustomNavBar.SimpleBottomNavBar(context, _onTap, navigationShell),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: featureFlagService.isFeatureEnabled('scanQRCode')
            ? GestureDetector(
                onDoubleTap: () => {getIt<ThemeController>().randomizeTheme()},
                onTap: () => {},
                child: const CircularScanLogoFAB(''),
              )
            : null,
        body: Stack(
          children: [
            navigationShell,
            //const MenuFAB(),
          ],
        ),
      ),
    );
  }
}
