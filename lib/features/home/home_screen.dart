import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_core/components/Extension.dart';
import 'package:ui_core/components/events/AnimatedMenuFABEvent.dart';
import 'package:ui_core/components/events/BottomNavBarController.dart';
import 'package:ui_core/components/screens/sheets/CustomBottomSheet.dart';
import 'package:your_drip/components/theme/theme_selector.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/core/FeatureFlag.dart';
import 'package:your_drip/di.dart';
import 'package:your_drip/features/home/home_footer.dart';

class CartBloc {}

class HomeAppBar extends StatelessWidget {
  final String _selectedStore;

  const HomeAppBar({super.key, required String selectedStore})
    : _selectedStore = selectedStore;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 48.scalablePixel,
      expandedHeight: 55.0.scalablePixel,
      floating: false,
      stretch: true,
      pinned: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colorScheme.primary,
              context.colorScheme.primaryContainer,
            ], // Set your gradient colors
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 10.scalablePixel),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Expanded(
                          child: Text(
                            _selectedStore.isNotEmpty
                                ? _selectedStore
                                : "Select Store",
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.modifiedTextTheme(
                              context.textTheme.displaySmall,
                              context.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.scalablePixel),
                  child: IconButton(
                    icon: Icon(
                      Icons.color_lens_outlined,
                      size: 23.0.scalablePixel,
                      color: context.colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      customBottomSheet(
                        context,
                        const ThemeSelector(),
                        isFloating: true,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.scalablePixel),
                  child: IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      size: 25.0.scalablePixel,
                      color: context.colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      context.goNamed(Constants.route_profilePage);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final String _selectedStore = "Select Store";

  final ScrollController _scrollController = ScrollController();
  final BottomNavBarController _navBarController = BottomNavBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: [
                HomeAppBar(selectedStore: _selectedStore),

                const SpiceItUpCard(),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: Placeholder()),
          if (getIt<IFeatureFlagService>().isFeatureEnabled('MenuFAB'))
            const AnimatedMenuFABEvent(child: Placeholder()),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    // Perform your refresh logic here. You can call an API, refresh state, etc.
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulate network request or any async operation
    setState(() {
      // Update the state if needed
    });
  }
}
