import 'package:sqflite/sqflite.dart';

import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../core/ids/local_profile_id.dart';
import '../../core/ids/scene_id.dart';
import '../../core/ids/stage_id.dart';
import '../../domain/journey/journey_checkpoint.dart';
import '../../domain/journey/journey_instance.dart';
import '../../domain/journey/journey_repository.dart';
import '../../domain/journey/journey_status.dart';
import '../local/database/app_database.dart';

final class SqliteJourneyRepository implements JourneyRepository {
  final AppDatabase database;
  const SqliteJourneyRepository(this.database);

  @override
  Future<JourneyInstance> createJourneyInstance(
    CreateJourneyInstanceRequest request,
  ) async {
    final existing = await getActiveJourney(
      request.localProfileId,
      request.journeyId,
    );
    if (existing != null) return existing;

    await database.transaction((tx) async {
      await tx.insert('journey_instances', {
        'journey_instance_id': request.journeyInstanceId.value,
        'local_profile_id': request.localProfileId.value,
        'journey_id': request.journeyId.value,
        'status': JourneyStatus.active.name,
        'started_at': request.startedAt.toUtc().toIso8601String(),
        'completed_at': null,
      });
      await tx.insert('journey_checkpoints', {
        'journey_instance_id': request.journeyInstanceId.value,
        'stage_id': request.initialStageId.value,
        'scene_id': request.initialSceneId.value,
        'interaction_id': request.initialInteractionId.value,
        'revision': 1,
        'updated_at': request.startedAt.toUtc().toIso8601String(),
      });
    });

    return (await getById(request.journeyInstanceId))!;
  }

  @override
  Future<JourneyInstance?> getActiveJourney(
    LocalProfileId profileId,
    JourneyId journeyId,
  ) async {
    final rows = await database.raw.query(
      'journey_instances',
      where: 'local_profile_id = ? AND journey_id = ? AND status = ?',
      whereArgs: [profileId.value, journeyId.value, JourneyStatus.active.name],
      limit: 1,
    );
    return rows.isEmpty ? null : _mapJourney(rows.first);
  }

  @override
  Future<JourneyInstance?> getById(JourneyInstanceId journeyInstanceId) async {
    final rows = await database.raw.query(
      'journey_instances',
      where: 'journey_instance_id = ?',
      whereArgs: [journeyInstanceId.value],
      limit: 1,
    );
    return rows.isEmpty ? null : _mapJourney(rows.first);
  }

  @override
  Future<JourneyCheckpoint?> getCheckpoint(
    JourneyInstanceId journeyInstanceId,
  ) async {
    final rows = await database.raw.query(
      'journey_checkpoints',
      where: 'journey_instance_id = ?',
      whereArgs: [journeyInstanceId.value],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return JourneyCheckpoint(
      journeyInstanceId: journeyInstanceId,
      stageId: StageId(row['stage_id']! as String),
      sceneId: SceneId(row['scene_id']! as String),
      interactionId: InteractionId(row['interaction_id']! as String),
      revision: row['revision']! as int,
      updatedAt: DateTime.parse(row['updated_at']! as String),
    );
  }

  JourneyInstance _mapJourney(Map<String, Object?> row) => JourneyInstance(
        id: JourneyInstanceId(row['journey_instance_id']! as String),
        localProfileId: LocalProfileId(row['local_profile_id']! as String),
        journeyId: JourneyId(row['journey_id']! as String),
        status: JourneyStatus.values.byName(row['status']! as String),
        startedAt: DateTime.parse(row['started_at']! as String),
        completedAt: row['completed_at'] == null
            ? null
            : DateTime.parse(row['completed_at']! as String),
      );
}
