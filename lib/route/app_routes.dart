import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_core/components/Extension.dart';
import 'package:ui_core/components/animations/Loader.dart';
import 'package:ui_core/components/screens/sheets/CustomBottomSheet.dart';
import 'package:ui_core/core/base/base_hive.dart';
import 'package:ui_core/core/base/base_inMemory.dart';
import 'package:your_drip/components/theme/theme_selector.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/core/FeatureFlag.dart';
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
                builder: (context, state) => const Home(),
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
        builder: (context, state) => const TestingPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      HiveStorage hive = getIt<HiveStorage>();
      bool? isSplashSeen = hive.get(Constants.IS_SPLASH_SEEN) ?? false;
      InMemoryStorage inMemory = getIt<InMemoryStorage>();
      // bool isDelSet = inMemory.get(Constants.IS_DELIVERY_TYPE_SET) ?? false;

      if (!isSplashSeen &&
          featureFlagService.isFeatureEnabled('showSplashScreenForNewUser')) {
        return '/splash';
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

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.scalablePixel),
      child: IconButton(
        icon: Icon(
          Icons.color_lens_outlined,
          size: 23.0.scalablePixel,
          color: context.colorScheme.onPrimary,
        ),
        onPressed: () {
          customBottomSheet(context, const ThemeSelector(), isFloating: true);
        },
      ),
    );
  }

  Future<void> handleOnboardingCompletion() async {
    await Loader.runTimeConsumingMethord(context, () async {
      await getIt<HiveStorage>().set(Constants.IS_SPLASH_SEEN, true);
      // Simulate some processing time (replace with your actual task)
      await Future.delayed(500.ms);
    });
  }

  @override
  void initState() {
    super.initState();
    handleOnboardingCompletion();
  }
}
