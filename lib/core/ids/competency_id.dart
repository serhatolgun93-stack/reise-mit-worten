import 'typed_id.dart';

final class CompetencyId extends TypedId {
  CompetencyId(String value) : super.validated(TypedId.validate(value, 'CompetencyId'));
}
