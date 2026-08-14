import 'typed_id.dart';

final class SceneId extends TypedId {
  SceneId(String value) : super.validated(TypedId.validate(value, 'SceneId'));
}
