import 'typed_id.dart';

final class ArtifactId extends TypedId {
  ArtifactId(String value) : super._(TypedId.validate(value, 'ArtifactId'));
}
