import 'typed_id.dart';

final class InteractionId extends TypedId {
  InteractionId(String value) : super._(TypedId.validate(value, 'InteractionId'));
}
