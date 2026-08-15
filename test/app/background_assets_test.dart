import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const assets = <String>[
    'assets/screens/english.jpg',
    'assets/screens/turkish.jpg',
    'assets/screens/greek.jpg',
  ];

  for (final asset in assets) {
    test('bundles $asset', () async {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0));
    });
  }
}
