import 'typed_id.dart';

final class JourneyId extends TypedId {
  JourneyId(String value) : super._(TypedId.validate(value, 'JourneyId'));
}
