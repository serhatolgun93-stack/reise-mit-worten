import 'package:flutter_test/flutter_test.dart';
import 'package:reise_mit_worten/core/ids/journey_id.dart';
import 'package:reise_mit_worten/core/ids/stage_id.dart';

void main() {
  test('JourneyId rejects empty values', () {
    expect(() => JourneyId(''), throwsArgumentError);
  });

  test('different typed IDs are not equal even with same value', () {
    expect(JourneyId('X'), isNot(StageId('X')));
  });
}
