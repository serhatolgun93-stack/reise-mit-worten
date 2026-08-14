import 'typed_id.dart';

final class CheckpointId extends TypedId {
  CheckpointId(String value) : super.validated(TypedId.validate(value, 'CheckpointId'));
}
