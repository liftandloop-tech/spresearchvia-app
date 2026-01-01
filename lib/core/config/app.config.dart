enum AppMode { development, production }

enum FeatureFlag { paymentMockEnabled, debugLogsEnabled, crashReportingEnabled }

class AppConfig {
  static const AppMode _mode = AppMode.production;
  static final policyURL = Uri.parse('https://researchvia.in/privacy-policy/');
  static final deleteURL = Uri.parse('https://researchvia.in/delete-account/');

  static const Map<FeatureFlag, bool> _defaultFlags = {
    FeatureFlag.paymentMockEnabled: false,
    FeatureFlag.debugLogsEnabled: false,
    FeatureFlag.crashReportingEnabled: true,
  };

  static const Map<FeatureFlag, bool> _developmentOverrides = {
    FeatureFlag.paymentMockEnabled: true,
    FeatureFlag.debugLogsEnabled: true,
    FeatureFlag.crashReportingEnabled: false,
  };

  static AppMode get mode => _mode;
  static bool get isDevelopment => _mode == AppMode.development;
  static bool get isProduction => _mode == AppMode.production;

  static bool isFeatureEnabled(FeatureFlag flag) {
    if (isDevelopment && _developmentOverrides.containsKey(flag)) {
      return _developmentOverrides[flag]!;
    }
    return _defaultFlags[flag] ?? false;
  }

  static String get baseUrl {
    switch (_mode) {
      case AppMode.development:
        return 'https://api.researchvia.in/api';
      case AppMode.production:
        return 'https://api.researchvia.in/api';
    }
  }

  static bool get useSecureStorage => isProduction;
  static Duration get tokenRefreshThreshold => const Duration(minutes: 5);

  static int get maxRetryAttempts => 3;
  static Duration get networkTimeout => const Duration(seconds: 30);

  static int get otpSize => 4;
}
