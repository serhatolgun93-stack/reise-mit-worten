import 'typed_id.dart';

final class CheckpointId extends TypedId {
  CheckpointId(String value) : super._(TypedId.validate(value, 'CheckpointId'));
}
