import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_id.dart';
import '../../core/ids/scene_id.dart';
import '../../core/ids/stage_id.dart';
import '../../domain/content/content_models.dart';

abstract interface class ContentRepository {
  Future<JourneyDefinition> getJourney(JourneyId id);
  Future<StageDefinition> getStage(StageId id);
  Future<SceneDefinition> getScene(SceneId id);
  Future<InteractionDefinition> getInteraction(InteractionId id);
}

final class InMemoryContentRepository implements ContentRepository {
  final ContentPackage package;
  const InMemoryContentRepository(this.package);

  @override Future<JourneyDefinition> getJourney(JourneyId id) async {
    if (package.journey.journeyId != id) throw StateError('Unknown journey ${id.value}');
    return package.journey;
  }
  @override Future<StageDefinition> getStage(StageId id) async => package.stages[id] ?? (throw StateError('Unknown stage ${id.value}'));
  @override Future<SceneDefinition> getScene(SceneId id) async => package.scenes[id] ?? (throw StateError('Unknown scene ${id.value}'));
  @override Future<InteractionDefinition> getInteraction(InteractionId id) async => package.interactions[id] ?? (throw StateError('Unknown interaction ${id.value}'));
}
