import 'typed_id.dart';

final class LocalProfileId extends TypedId {
  LocalProfileId(String value) : super.validated(TypedId.validate(value, 'LocalProfileId'));
}
