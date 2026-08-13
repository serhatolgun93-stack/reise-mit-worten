import 'typed_id.dart';

final class InteractionCommitId extends TypedId {
  InteractionCommitId(String value) : super._(TypedId.validate(value, 'InteractionCommitId'));
}
