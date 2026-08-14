import 'typed_id.dart';

final class InteractionCommitId extends TypedId {
  InteractionCommitId(String value) : super.validated(TypedId.validate(value, 'InteractionCommitId'));
}
