import 'typed_id.dart';

final class ProfileId extends TypedId {
  ProfileId(String value) : super._(TypedId.validate(value, 'ProfileId'));
}
