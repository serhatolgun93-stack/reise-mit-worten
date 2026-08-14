import 'typed_id.dart';

final class CharacterId extends TypedId {
  CharacterId(String value) : super.validated(TypedId.validate(value, 'CharacterId'));
}
