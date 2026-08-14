import 'typed_id.dart';

final class ArtifactId extends TypedId {
  ArtifactId(String value) : super.validated(TypedId.validate(value, 'ArtifactId'));
}
