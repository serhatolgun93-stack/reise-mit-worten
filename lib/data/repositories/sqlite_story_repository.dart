import '../../core/ids/interaction_commit_id.dart';
import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../core/ids/story_event_id.dart';
import '../../domain/story/story_event.dart';
import '../../domain/story/story_repository.dart';
import '../../domain/story/story_value.dart';
import '../local/database/app_database.dart';

final class SqliteStoryRepository implements StoryRepository {
  final AppDatabase database;
  const SqliteStoryRepository(this.database);

  @override
  Future<List<StoryEvent>> getEvents(JourneyInstanceId journeyInstanceId) async {
    final rows = await database.raw.query(
      'story_events',
      where: 'journey_instance_id = ?',
      whereArgs: [journeyInstanceId.value],
      orderBy: 'sequence_number ASC',
    );
    return rows.map(_mapEvent).toList(growable: false);
  }

  @override
  Future<int> getLastSequenceNumber(JourneyInstanceId journeyInstanceId) async {
    final rows = await database.raw.rawQuery(
      'SELECT MAX(sequence_number) AS max_seq FROM story_events WHERE journey_instance_id = ?',
      [journeyInstanceId.value],
    );
    return (rows.first['max_seq'] as int?) ?? 0;
  }

  @override
  Future<StoryValue?> getStoryValue(
    JourneyInstanceId journeyInstanceId,
    String key,
  ) async {
    final rows = await database.raw.query(
      'story_value_projections',
      where: 'journey_instance_id = ? AND value_key = ?',
      whereArgs: [journeyInstanceId.value, key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return StoryValue(
      key: key,
      type: row['value_type']! as String,
      payload: row['value_payload']! as String,
      sourceEventId: row['source_event_id']! as String,
      updatedAt: DateTime.parse(row['updated_at']! as String),
    );
  }

  StoryEvent _mapEvent(Map<String, Object?> row) => StoryEvent(
        id: StoryEventId(row['event_id']! as String),
        interactionCommitId: row['interaction_commit_id'] == null
            ? null
            : InteractionCommitId(row['interaction_commit_id']! as String),
        journeyInstanceId:
            JourneyInstanceId(row['journey_instance_id']! as String),
        sequenceNumber: row['sequence_number']! as int,
        eventType: row['event_type']! as String,
        payload: row['payload']! as String,
        payloadVersion: row['payload_version']! as int,
        sourceInteractionId: row['source_interaction_id'] == null
            ? null
            : InteractionId(row['source_interaction_id']! as String),
        contentVersion: row['content_version']! as String,
        createdAt: DateTime.parse(row['created_at']! as String),
      );
}
