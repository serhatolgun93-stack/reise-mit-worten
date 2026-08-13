import 'typed_id.dart';

final class JourneyInstanceId extends TypedId {
  JourneyInstanceId(String value) : super._(TypedId.validate(value, 'JourneyInstanceId'));
}
