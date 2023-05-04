enum BuildVariant { internal, staging, production }

class BuildConfig {
  final String appName;

  static late BuildConfig _buildConfig;

  BuildConfig._({
    required this.appName,
  });

  static void init({
    required appName,
  }) {
    _buildConfig = BuildConfig._(
      appName: appName,
    );
  }

  static BuildConfig getInstance() => _buildConfig;
}
