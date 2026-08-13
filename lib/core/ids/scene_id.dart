import 'typed_id.dart';

final class SceneId extends TypedId {
  SceneId(String value) : super._(TypedId.validate(value, 'SceneId'));
}
