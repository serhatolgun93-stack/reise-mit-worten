import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const assets = <String>[
    'assets/backgrounds/english_london.png',
    'assets/backgrounds/turkish_istanbul.png',
    'assets/backgrounds/greek_santorini.png',
  ];

  for (final asset in assets) {
    test('bundles $asset', () async {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0));
    });
  }
}
