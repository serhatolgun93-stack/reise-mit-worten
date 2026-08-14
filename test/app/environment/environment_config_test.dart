import 'package:flutter_test/flutter_test.dart';
import 'package:reise_mit_worten/app/environment/app_environment.dart';
import 'package:reise_mit_worten/app/environment/environment_config.dart';

void main() {
  test('default environment is dev', () {
    final config = EnvironmentConfig.resolve();
    expect(config.environment, AppEnvironment.dev);
    expect(config.enableDeveloperTools, isTrue);
  });
}
