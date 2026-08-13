import 'typed_id.dart';

final class LocalProfileId extends TypedId {
  LocalProfileId(String value) : super._(TypedId.validate(value, 'LocalProfileId'));
}
