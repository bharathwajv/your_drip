import 'dart:convert';

abstract class IFeatureFlagService {
  String getAppBuildVersion();
  Future<void> initialize();
  bool isFeatureEnabled(String featureName);
}

class StaticFeatureFlagService implements IFeatureFlagService {
  Map<String, dynamic> _featureFlags = {};
  String _appBuildVersion = '';

  @override
  String getAppBuildVersion() {
    return _appBuildVersion;
  }

  @override
  Future<void> initialize() async {
    const String jsonString = """{
                              "appBuildVersion": "1.0.0",
                              "features": {
                                "scanQRCode": false,
                                "askDeliveryTypeOnAppOpen": false,
                                "showSplashScreenForNewUser": true,
                                "MenuFAB": true
                              }
                            }""";

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _featureFlags = jsonMap['features'];
    _appBuildVersion = jsonMap['appBuildVersion'];
  }

  @override
  bool isFeatureEnabled(String featureName) {
    return _featureFlags[featureName] ?? false;
  }
}
