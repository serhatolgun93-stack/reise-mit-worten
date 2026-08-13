import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../domain/content/content_models.dart';
import '../../domain/journey/journey_checkpoint.dart';

sealed class JourneyRuntimeState { const JourneyRuntimeState(); }
final class RuntimeIdle extends JourneyRuntimeState { const RuntimeIdle(); }
final class RuntimeLoading extends JourneyRuntimeState { const RuntimeLoading(); }
final class RuntimeReady extends JourneyRuntimeState {
  final JourneyInstanceId journeyInstanceId;
  final JourneyCheckpoint checkpoint;
  final StageDefinition stage;
  final SceneDefinition scene;
  final InteractionDefinition interaction;
  final InteractionViewModel viewModel;
  const RuntimeReady({required this.journeyInstanceId, required this.checkpoint, required this.stage, required this.scene, required this.interaction, required this.viewModel});
}
final class RuntimeSubmitting extends JourneyRuntimeState { final InteractionId interactionId; const RuntimeSubmitting(this.interactionId); }
final class RuntimeStageComplete extends JourneyRuntimeState { const RuntimeStageComplete(); }
final class RuntimeFailure extends JourneyRuntimeState { final String code; const RuntimeFailure(this.code); }

sealed class InteractionViewModel { String get interactionId; }
final class DialogueViewModel implements InteractionViewModel {
  @override final String interactionId;
  final String speakerName;
  final String text;
  final String? audioId;
  const DialogueViewModel({required this.interactionId, required this.speakerName, required this.text, this.audioId});
}
final class ChoiceOptionViewModel { final String id; final String label; final String semanticValue; const ChoiceOptionViewModel({required this.id, required this.label, required this.semanticValue}); }
final class ChoiceViewModel implements InteractionViewModel {
  @override final String interactionId;
  final String prompt;
  final List<ChoiceOptionViewModel> options;
  final bool confirmationRequired;
  const ChoiceViewModel({required this.interactionId, required this.prompt, required this.options, required this.confirmationRequired});
}
final class TextInputViewModel implements InteractionViewModel {
  @override final String interactionId;
  final String prompt;
  final TextInputType inputType;
  final int maxLength;
  final String keyboardLocaleHint;
  const TextInputViewModel({required this.interactionId, required this.prompt, required this.inputType, required this.maxLength, required this.keyboardLocaleHint});
}

enum SpeechShellState { ready, listening, processing, uncertain, unavailable }

final class ListeningViewModel implements InteractionViewModel {
  @override final String interactionId;
  final String prompt;
  final String audioId;
  final ListeningResponseType responseType;
  final bool alternativeAvailable;
  const ListeningViewModel({required this.interactionId, required this.prompt, required this.audioId, required this.responseType, required this.alternativeAvailable});
}

final class SpeechViewModel implements InteractionViewModel {
  @override final String interactionId;
  final String prompt;
  final SpeechShellState state;
  final bool textFallbackAvailable;
  final bool helpAvailable;
  const SpeechViewModel({required this.interactionId, required this.prompt, required this.state, required this.textFallbackAvailable, required this.helpAvailable});
}

final class HelpViewModel {
  final String? instruction;
  final String? strategy;
  final List<String> languageSteps;
  const HelpViewModel({this.instruction, this.strategy, this.languageSteps = const []});
  bool get isAvailable => instruction != null || strategy != null || languageSteps.isNotEmpty;
}
