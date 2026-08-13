import '../../core/ids/competency_id.dart';
import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';
import 'evidence_event.dart';

abstract interface class EvidenceRepository {
  Future<List<EvidenceEvent>> getForInteraction(
    JourneyInstanceId journeyInstanceId,
    InteractionId interactionId,
  );

  Future<List<EvidenceEvent>> getForCompetency(
    JourneyInstanceId journeyInstanceId,
    CompetencyId competencyId,
  );
}
