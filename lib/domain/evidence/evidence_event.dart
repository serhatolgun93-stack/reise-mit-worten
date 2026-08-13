import '../../core/ids/competency_id.dart';
import '../../core/ids/evidence_id.dart';
import '../../core/ids/interaction_commit_id.dart';
import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';

enum EvidenceModality { choice, text, speech, listening }
enum EvidenceSemanticResult { success, partial, notDemonstrated }
enum EvidenceType { encounter, application }

final class EvidenceEvent {
  final EvidenceId id;
  final InteractionCommitId interactionCommitId;
  final JourneyInstanceId journeyInstanceId;
  final CompetencyId competencyId;
  final InteractionId interactionId;
  final String contentVersion;
  final EvidenceModality modality;
  final EvidenceSemanticResult semanticResult;
  final EvidenceType evidenceType;
  final String? languageObjectId;
  final String helpPayload;
  final DateTime createdAt;

  const EvidenceEvent({
    required this.id,
    required this.interactionCommitId,
    required this.journeyInstanceId,
    required this.competencyId,
    required this.interactionId,
    required this.contentVersion,
    required this.modality,
    required this.semanticResult,
    required this.createdAt,
    this.evidenceType = EvidenceType.application,
    this.languageObjectId,
    this.helpPayload = '{}',
  });
}
