import 'typed_id.dart';

final class ContentVersionId extends TypedId {
  ContentVersionId(String value) : super.validated(TypedId.validate(value, 'ContentVersionId'));
}
