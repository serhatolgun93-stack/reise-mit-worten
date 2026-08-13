import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../core/ids/scene_id.dart';
import '../../core/ids/stage_id.dart';

final class JourneyCheckpoint {
  final JourneyInstanceId journeyInstanceId;
  final StageId stageId;
  final SceneId sceneId;
  final InteractionId interactionId;
  final int revision;
  final DateTime updatedAt;

  JourneyCheckpoint({
    required this.journeyInstanceId,
    required this.stageId,
    required this.sceneId,
    required this.interactionId,
    required this.revision,
    required this.updatedAt,
  }) {
    if (revision < 1) {
      throw ArgumentError.value(revision, 'revision', 'must be >= 1');
    }
  }
}
