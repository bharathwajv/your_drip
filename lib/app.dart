import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ui_core/components/screens/CustomErrorPage.dart';
import 'package:your_drip/components/theme/theme_controller.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/di.dart';
import 'package:your_drip/features/LinkPreview.dart';
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
    BackgroundRemover.instance.initializeOrt();

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (value) async {
        print("reciveD");
        final service = LinkPreviewService();
        final preview = await service.fetchPreview(
          value[0].path,
          timeoutSec: 5,
        );

        if (preview.isError) {
          print('Error fetching preview: ${preview.errorMessage}');
        } else {
          print('URL: ${preview.url}');
          print('Title: ${preview.title}');
          print('Description: ${preview.description}');
          print('Image: ${preview.image}');
          print('Site Name: ${preview.siteName}');

          // Navigate to the image preview page
          if (mounted) {
            final context = AppRoutes.rootNavigatorKey.currentContext;
            if (context != null) {
              context.pushNamed(
                'image_preview',
                extra: {
                  'imagePath': preview.image,
                  'title': preview.title ?? 'Image Preview',
                },
              );
            }
          }
        }
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
    ReceiveSharingIntent.instance.getInitialMedia().then((value) async {
      if (value.isNotEmpty) {
        final service = LinkPreviewService();
        final preview = await service.fetchPreview(
          value[0].path,
          timeoutSec: 5,
        );

        if (!preview.isError && mounted) {
          final context = AppRoutes.rootNavigatorKey.currentContext;
          if (context != null) {
            context.pushNamed(
              'image_preview',
              extra: {
                'imagePath': value[0].path,
                'title': preview.title ?? 'Image Preview',
              },
            );
          }
        }
      }

      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        print(_sharedFiles.map((f) => f.toMap()));
      });
    });
  }
}
