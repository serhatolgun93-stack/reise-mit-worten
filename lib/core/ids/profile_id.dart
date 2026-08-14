import 'typed_id.dart';

final class ProfileId extends TypedId {
  ProfileId(String value) : super.validated(TypedId.validate(value, 'ProfileId'));
}
