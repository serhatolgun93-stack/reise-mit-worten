import '../../core/ids/journey_instance_id.dart';
import 'story_event.dart';
import 'story_value.dart';

abstract interface class StoryRepository {
  Future<List<StoryEvent>> getEvents(JourneyInstanceId journeyInstanceId);
  Future<int> getLastSequenceNumber(JourneyInstanceId journeyInstanceId);
  Future<StoryValue?> getStoryValue(
    JourneyInstanceId journeyInstanceId,
    String key,
  );
}
