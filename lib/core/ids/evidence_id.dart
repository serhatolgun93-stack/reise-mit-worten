import 'typed_id.dart';

final class EvidenceId extends TypedId {
  EvidenceId(String value) : super.validated(TypedId.validate(value, 'EvidenceId'));
}
