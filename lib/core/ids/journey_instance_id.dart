import 'typed_id.dart';

final class JourneyInstanceId extends TypedId {
  JourneyInstanceId(String value) : super.validated(TypedId.validate(value, 'JourneyInstanceId'));
}
