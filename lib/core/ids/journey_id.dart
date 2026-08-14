import 'typed_id.dart';

final class JourneyId extends TypedId {
  JourneyId(String value) : super.validated(TypedId.validate(value, 'JourneyId'));
}
