import 'typed_id.dart';

final class LanguageObjectId extends TypedId {
  LanguageObjectId(String value) : super.validated(TypedId.validate(value, 'LanguageObjectId'));
}
