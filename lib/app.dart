import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ui_core/components/screens/CustomErrorPage.dart';
import 'package:your_drip/components/theme/theme_controller.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/di.dart';
import 'package:your_drip/route/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        //error screen
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return CustomErrorPage(
            errorDetails: errorDetails,
            image: Constants.Asset_RouterOffline,
          );
        };
        return ValueListenableBuilder<ThemeData>(
          valueListenable: getIt<ThemeController>().currentTheme,
          builder: (context, themeData, _) {
            return MaterialApp.router(
              theme: themeData,
              debugShowCheckedModeBanner: false,
              routerConfig: AppRoutes.router,
            );
          },
        );
      },
    );
  }
}
