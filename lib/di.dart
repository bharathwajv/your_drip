import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui_core/core/base/base_hive.dart';
import 'package:ui_core/core/base/base_inMemory.dart';
import 'package:your_drip/components/theme/theme_controller.dart';
import 'package:your_drip/constant/constants.dart';
import 'package:your_drip/core/FeatureFlag.dart';

final GetIt getIt = GetIt.instance;

class AppDependencies {
  Future<void> initialize() async {
    // Business logic

    // Core
    getIt.registerSingleton<IFeatureFlagService>(StaticFeatureFlagService());
    await getIt<IFeatureFlagService>().initialize();

    getIt.registerLazySingleton<InMemoryStorage>(() => InMemoryStorage());
    getIt.registerLazySingleton<HiveStorage>(() => HiveStorage());
    Hive.init(
      kIsWeb
          ? HydratedStorageDirectory.web.path
          : (await getApplicationDocumentsDirectory()).path,
    );
    await getIt<HiveStorage>().initBloc(Constants.BOX_APP);

    getIt.registerLazySingleton<ThemeController>(() => ThemeController());
    await getIt.allReady();
  }
}
