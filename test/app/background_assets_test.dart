import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const approved = <String, ({int width, int height, int minBytes})>{
    'assets/backgrounds/english_london.png': (width: 467, height: 720, minBytes: 100000),
    'assets/backgrounds/turkish_istanbul.png': (width: 720, height: 480, minBytes: 100000),
    'assets/backgrounds/greek_santorini.png': (width: 1600, height: 1066, minBytes: 30000),
  };

  for (final entry in approved.entries) {
    test('bundles approved ${entry.key}', () async {
      final data = await rootBundle.load(entry.key);
      expect(data.lengthInBytes, greaterThan(entry.value.minBytes));

      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      expect(frame.image.width, entry.value.width);
      expect(frame.image.height, entry.value.height);
      codec.dispose();
    });
  }
}
