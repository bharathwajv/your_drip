import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ui_core/components/screens/CustomErrorPage.dart';
import 'package:your_drip/components/theme/theme_controller.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/di.dart';
import 'package:your_drip/route/app_routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

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

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (value) {
        print("reciveD");
        setState(() {
          _sharedFiles.clear();
          _sharedFiles.addAll(value);

          print(_sharedFiles.map((f) => f.toMap()));
        });
      },
      onError: (err) {
        print("getIntentDataStream error: $err");
      },
    );

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        print(_sharedFiles.map((f) => f.toMap()));

        // Tell the library that we are done processing the intent.
      });
    });
  }
}
