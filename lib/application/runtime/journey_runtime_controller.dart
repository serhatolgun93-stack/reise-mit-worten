import '../../core/ids/journey_instance_id.dart';
import '../../data/content/content_repository.dart';
import '../../domain/journey/journey_repository.dart';
import 'interaction_view_model_builder.dart';
import 'runtime_models.dart';

final class JourneyRuntimeController {
  final JourneyRepository journeyRepository;
  final ContentRepository contentRepository;
  final InteractionViewModelBuilder viewModelBuilder;
  JourneyRuntimeState _state = const RuntimeIdle();
  JourneyRuntimeState get state => _state;

  JourneyRuntimeController({required this.journeyRepository, required this.contentRepository, required this.viewModelBuilder});

  Future<JourneyRuntimeState> load(JourneyInstanceId instanceId) async {
    _state = const RuntimeLoading();
    try {
      final checkpoint = await journeyRepository.getCheckpoint(instanceId);
      if (checkpoint == null) return _state = const RuntimeFailure('CHECKPOINT_NOT_FOUND');
      final stage = await contentRepository.getStage(checkpoint.stageId);
      final scene = await contentRepository.getScene(checkpoint.sceneId);
      final interaction = await contentRepository.getInteraction(checkpoint.interactionId);
      final viewModel = viewModelBuilder.build(interaction);
      return _state = RuntimeReady(journeyInstanceId: instanceId, checkpoint: checkpoint, stage: stage, scene: scene, interaction: interaction, viewModel: viewModel);
    } catch (_) {
      return _state = const RuntimeFailure('RUNTIME_LOAD_FAILED');
    }
  }
}
