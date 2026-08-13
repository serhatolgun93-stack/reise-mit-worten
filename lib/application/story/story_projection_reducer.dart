import '../../domain/story/story_event.dart';
import '../../domain/story/story_event_payloads.dart';
import '../../domain/story/story_value.dart';
import '../../domain/story/story_value_registry.dart';

final class StoryProjectionReducer {
  final StoryEventPayloadCodec codec;
  const StoryProjectionReducer({this.codec = const StoryEventPayloadCodec()});

  Map<String, StoryValue> apply(Map<String, StoryValue> current, StoryEvent event) {
    final next = Map<String, StoryValue>.from(current);
    final payload = codec.decode(event.eventType, event.payloadVersion, event.payload);
    switch (payload) {
      case ItemOrderedPayload(:final itemId):
        next[StoryValueRegistry.orderedItem.key] = StoryValue(
          key: StoryValueRegistry.orderedItem.key,
          type: StoryValueRegistry.orderedItem.type.name,
          payload: itemId,
          sourceEventId: event.id.value,
          updatedAt: event.createdAt,
        );
      case StoryNameSetPayload(:final name):
        next[StoryValueRegistry.userName.key] = StoryValue(
          key: StoryValueRegistry.userName.key,
          type: StoryValueRegistry.userName.type.name,
          payload: name,
          sourceEventId: event.id.value,
          updatedAt: event.createdAt,
        );
      default:
        break;
    }
    return next;
  }
}
