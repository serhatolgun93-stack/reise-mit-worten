import 'typed_id.dart';

final class InteractionId extends TypedId {
  InteractionId(String value) : super.validated(TypedId.validate(value, 'InteractionId'));
}
