import 'typed_id.dart';

final class EvidenceId extends TypedId {
  EvidenceId(String value) : super._(TypedId.validate(value, 'EvidenceId'));
}
