import 'app_environment.dart';

enum LogLevel { debug, info, warning, error }

class EnvironmentConfig {
  final AppEnvironment environment;
  final String contentChannel;
  final bool enableDeveloperTools;
  final LogLevel logLevel;

  const EnvironmentConfig({
    required this.environment,
    required this.contentChannel,
    required this.enableDeveloperTools,
    required this.logLevel,
  });

  static EnvironmentConfig resolve() {
    const flavor = String.fromEnvironment('RMW_ENV', defaultValue: 'dev');
    return switch (flavor) {
      'production' => const EnvironmentConfig(
          environment: AppEnvironment.production,
          contentChannel: 'production',
          enableDeveloperTools: false,
          logLevel: LogLevel.warning,
        ),
      'staging' => const EnvironmentConfig(
          environment: AppEnvironment.staging,
          contentChannel: 'staging',
          enableDeveloperTools: true,
          logLevel: LogLevel.info,
        ),
      _ => const EnvironmentConfig(
          environment: AppEnvironment.dev,
          contentChannel: 'dev',
          enableDeveloperTools: true,
          logLevel: LogLevel.debug,
        ),
    };
  }
}
