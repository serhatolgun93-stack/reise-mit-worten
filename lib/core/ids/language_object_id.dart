import 'typed_id.dart';

final class LanguageObjectId extends TypedId {
  LanguageObjectId(String value) : super._(TypedId.validate(value, 'LanguageObjectId'));
}
