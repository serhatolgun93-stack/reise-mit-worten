import 'typed_id.dart';

final class StageId extends TypedId {
  StageId(String value) : super._(TypedId.validate(value, 'StageId'));
}
