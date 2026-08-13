import 'typed_id.dart';

final class CompetencyId extends TypedId {
  CompetencyId(String value) : super._(TypedId.validate(value, 'CompetencyId'));
}
