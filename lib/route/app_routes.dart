import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_core/core/base/base_hive.dart';
import 'package:ui_core/core/base/base_inMemory.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/core/FeatureFlag.dart';
import 'package:your_drip/features/ImageCrop/test.dart';
import 'package:your_drip/features/ImagePreview/image_preview_page.dart';
import 'package:your_drip/features/Splash/splash_screen.dart';
import 'package:your_drip/route/scaffold/ScaffoldWithNavbar.dart';
import 'package:your_drip/route/testing_page.dart';

import '../di.dart';

class AppRoutes {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _sectionNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: "selection",
  );
  static final featureFlagService = getIt<IFeatureFlagService>();
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    // errorBuilder: (BuildContext context, GoRouterState state) {
    //   return const RouterOfflineScreen(Constants.Asset_RouterOffline);
    // },
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavbar(navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _sectionNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                name: Constants.route_home,
                path: '/',
                builder: (context, state) => const ImagePicker(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: Constants.route_profilePage,
                path: '/profile',
                builder: (context, state) => TestingPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: Constants.APP_NAME,
        path: '/test',
        builder: (context, state) => const TestingPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: Constants.route_splash,
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: "imagepicker",
        path: '/imagepicker',
        builder: (context, state) => const ImagePicker(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        name: "image_preview",
        path: '/image-preview',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ImagePreviewPage(
            imagePath: extra?['imagePath'] as String,
            title: extra?['title'] as String? ?? 'Image Preview',
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      HiveStorage hive = getIt<HiveStorage>();
      bool? isSplashSeen = hive.get(Constants.IS_SPLASH_SEEN) ?? false;
      InMemoryStorage inMemory = getIt<InMemoryStorage>();
      // bool isDelSet = inMemory.get(Constants.IS_DELIVERY_TYPE_SET) ?? false;

      if (!isSplashSeen &&
          featureFlagService.isFeatureEnabled('showSplashScreenForNewUser')) {
        // return '/splash';
      } else {
        // bool? isLoggedIn = hive.get(Constants.IS_LOGGED_IN) ?? false;
        // if (!isLoggedIn) {
        //   //return '/login';
        // }
      }
      return null;
    },
  );
}
