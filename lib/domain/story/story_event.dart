import '../../core/ids/interaction_commit_id.dart';
import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../core/ids/story_event_id.dart';

final class StoryEvent {
  final StoryEventId id;
  final InteractionCommitId? interactionCommitId;
  final JourneyInstanceId journeyInstanceId;
  final int sequenceNumber;
  final String eventType;
  final String payload;
  final int payloadVersion;
  final InteractionId? sourceInteractionId;
  final String contentVersion;
  final DateTime createdAt;

  const StoryEvent({
    required this.id,
    required this.journeyInstanceId,
    required this.sequenceNumber,
    required this.eventType,
    required this.payload,
    required this.payloadVersion,
    required this.contentVersion,
    required this.createdAt,
    this.interactionCommitId,
    this.sourceInteractionId,
  });
}
