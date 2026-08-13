import 'typed_id.dart';

final class ContentVersionId extends TypedId {
  ContentVersionId(String value) : super._(TypedId.validate(value, 'ContentVersionId'));
}
