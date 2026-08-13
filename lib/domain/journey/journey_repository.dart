import '../../core/ids/journey_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../core/ids/local_profile_id.dart';
import '../../core/ids/scene_id.dart';
import '../../core/ids/stage_id.dart';
import '../../core/ids/interaction_id.dart';
import 'journey_checkpoint.dart';
import 'journey_instance.dart';

final class CreateJourneyInstanceRequest {
  final JourneyInstanceId journeyInstanceId;
  final LocalProfileId localProfileId;
  final JourneyId journeyId;
  final StageId initialStageId;
  final SceneId initialSceneId;
  final InteractionId initialInteractionId;
  final DateTime startedAt;

  const CreateJourneyInstanceRequest({
    required this.journeyInstanceId,
    required this.localProfileId,
    required this.journeyId,
    required this.initialStageId,
    required this.initialSceneId,
    required this.initialInteractionId,
    required this.startedAt,
  });
}

abstract interface class JourneyRepository {
  Future<JourneyInstance> createJourneyInstance(
    CreateJourneyInstanceRequest request,
  );

  Future<JourneyInstance?> getActiveJourney(
    LocalProfileId profileId,
    JourneyId journeyId,
  );

  Future<JourneyInstance?> getById(JourneyInstanceId journeyInstanceId);

  Future<JourneyCheckpoint?> getCheckpoint(
    JourneyInstanceId journeyInstanceId,
  );
}
