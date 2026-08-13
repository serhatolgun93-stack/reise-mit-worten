import '../../core/ids/competency_id.dart';
import '../../core/ids/evidence_id.dart';
import '../../core/ids/interaction_commit_id.dart';
import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../domain/evidence/evidence_event.dart';
import '../../domain/evidence/evidence_repository.dart';
import '../local/database/app_database.dart';

final class SqliteEvidenceRepository implements EvidenceRepository {
  final AppDatabase database;
  const SqliteEvidenceRepository(this.database);

  @override
  Future<List<EvidenceEvent>> getForInteraction(
    JourneyInstanceId journeyInstanceId,
    InteractionId interactionId,
  ) => _query(
        'journey_instance_id = ? AND interaction_id = ?',
        [journeyInstanceId.value, interactionId.value],
      );

  @override
  Future<List<EvidenceEvent>> getForCompetency(
    JourneyInstanceId journeyInstanceId,
    CompetencyId competencyId,
  ) => _query(
        'journey_instance_id = ? AND competency_id = ?',
        [journeyInstanceId.value, competencyId.value],
      );

  Future<List<EvidenceEvent>> _query(String where, List<Object?> args) async {
    final rows = await database.raw.query(
      'evidence_events',
      where: where,
      whereArgs: args,
      orderBy: 'created_at ASC',
    );
    return rows.map(_map).toList(growable: false);
  }

  EvidenceEvent _map(Map<String, Object?> row) => EvidenceEvent(
        id: EvidenceId(row['evidence_id']! as String),
        interactionCommitId:
            InteractionCommitId(row['interaction_commit_id']! as String),
        journeyInstanceId:
            JourneyInstanceId(row['journey_instance_id']! as String),
        competencyId: CompetencyId(row['competency_id']! as String),
        interactionId: InteractionId(row['interaction_id']! as String),
        contentVersion: row['content_version']! as String,
        modality: EvidenceModality.values.byName(row['modality']! as String),
        semanticResult: EvidenceSemanticResult.values
            .byName(row['semantic_result']! as String),
        evidenceType: EvidenceType.values.byName((row['evidence_type'] as String?) ?? 'application'),
        languageObjectId: row['language_object_id'] as String?,
        helpPayload: (row['help_payload'] as String?) ?? '{}',
        createdAt: DateTime.parse(row['created_at']! as String),
      );
}
