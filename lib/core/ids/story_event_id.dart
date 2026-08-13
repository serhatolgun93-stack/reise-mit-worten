import 'typed_id.dart';

final class StoryEventId extends TypedId {
  StoryEventId(String value) : super._(TypedId.validate(value, 'StoryEventId'));
}
