import 'typed_id.dart';

final class StoryEventId extends TypedId {
  StoryEventId(String value) : super.validated(TypedId.validate(value, 'StoryEventId'));
}
