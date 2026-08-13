import 'typed_id.dart';

final class CharacterId extends TypedId {
  CharacterId(String value) : super._(TypedId.validate(value, 'CharacterId'));
}
