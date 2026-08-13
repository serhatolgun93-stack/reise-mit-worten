import '../../core/ids/journey_instance_id.dart';

abstract interface class StoryProjectionRebuilder {
  Future<void> rebuild(JourneyInstanceId journeyInstanceId);
}

final class StoryIntegrityFailure implements Exception {
  final String message;
  const StoryIntegrityFailure(this.message);
  @override
  String toString() => 'STORY_INTEGRITY: $message';
}
