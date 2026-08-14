import '../../core/ids/character_id.dart';
import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_id.dart';
import '../../core/ids/scene_id.dart';
import '../../core/ids/stage_id.dart';

enum InteractionType { dialogue, choice, textInput, listening, speech }
enum InteractionModality { dialogue, choice, text, speech, listening }
enum ContinuePolicy { userContinue, autoAfterAudio }
enum TextInputType { openName, targetLanguageText }
enum StoryActionType { setStoryValue, emitStoryEvent, teachCharacterFact, completeStage }
enum SceneConditionType { always, storyValueEquals, eventOccurred, characterKnows, interactionResult }

final class ContentManifest {
  final String packageId;
  final String packageVersion;
  final int contractVersion;
  final String languageId;
  final JourneyId journeyId;
  final String minimumAppVersion;
  final StageId entryStageId;
  final String checksum;
  const ContentManifest({required this.packageId,required this.packageVersion,required this.contractVersion,required this.languageId,required this.journeyId,required this.minimumAppVersion,required this.entryStageId,required this.checksum});
}
final class JourneyDefinition {
  final JourneyId journeyId; final String languageId; final String locationId; final String level; final String titleRef; final List<StageId> stageOrder;
  const JourneyDefinition({required this.journeyId,required this.languageId,required this.locationId,required this.level,required this.titleRef,required this.stageOrder});
}
final class StageDefinition {
  final StageId stageId; final JourneyId journeyId; final int order; final String titleRef; final SceneId entrySceneId; final List<SceneId> sceneIds; final List<SceneId> completionSceneIds;
  const StageDefinition({required this.stageId,required this.journeyId,required this.order,required this.titleRef,required this.entrySceneId,required this.sceneIds,required this.completionSceneIds});
}
final class SceneDefinition {
  final SceneId sceneId; final StageId stageId; final List<CharacterId> characterIds; final List<InteractionId> interactionIds; final List<NextSceneRule> nextSceneRules;
  const SceneDefinition({required this.sceneId,required this.stageId,required this.characterIds,required this.interactionIds,required this.nextSceneRules});
}
sealed class InteractionDefinition {
  InteractionId get interactionId; String get promptRef; List<InteractionModality> get allowedModalities; String? get evaluationPolicyRef; List<StoryActionDefinition> get storyActions; List<EvidenceMappingDefinition> get evidenceMappings; InteractionType get type;
}
final class DialogueInteractionDefinition implements InteractionDefinition {
  @override final InteractionId interactionId; @override final String promptRef; @override final List<InteractionModality> allowedModalities; @override final String? evaluationPolicyRef; @override final List<StoryActionDefinition> storyActions; @override final List<EvidenceMappingDefinition> evidenceMappings; final CharacterId speakerId; final String textRef; final String? audioRef; final ContinuePolicy continuePolicy; @override InteractionType get type=>InteractionType.dialogue;
  const DialogueInteractionDefinition({required this.interactionId,required this.promptRef,required this.speakerId,required this.textRef,this.audioRef,this.continuePolicy=ContinuePolicy.userContinue,this.allowedModalities=const [InteractionModality.dialogue],this.evaluationPolicyRef,this.storyActions=const [],this.evidenceMappings=const []});
}
final class ChoiceOptionDefinition { final String optionId; final String labelRef; final String semanticValue; const ChoiceOptionDefinition({required this.optionId,required this.labelRef,required this.semanticValue}); }
final class ChoiceInteractionDefinition implements InteractionDefinition {
  @override final InteractionId interactionId; @override final String promptRef; @override final List<InteractionModality> allowedModalities; @override final String? evaluationPolicyRef; @override final List<StoryActionDefinition> storyActions; @override final List<EvidenceMappingDefinition> evidenceMappings; final List<ChoiceOptionDefinition> options; final bool confirmationRequired; @override InteractionType get type=>InteractionType.choice;
  const ChoiceInteractionDefinition({required this.interactionId,required this.promptRef,required this.options,this.confirmationRequired=true,this.allowedModalities=const [InteractionModality.choice],this.evaluationPolicyRef,this.storyActions=const [],this.evidenceMappings=const []});
}
final class TextInputInteractionDefinition implements InteractionDefinition {
  @override final InteractionId interactionId; @override final String promptRef; @override final List<InteractionModality> allowedModalities; @override final String? evaluationPolicyRef; @override final List<StoryActionDefinition> storyActions; @override final List<EvidenceMappingDefinition> evidenceMappings; final TextInputType inputType; final int maxLength; final String normalizationPolicy; @override InteractionType get type=>InteractionType.textInput;
  const TextInputInteractionDefinition({required this.interactionId,required this.promptRef,required this.inputType,required this.maxLength,required this.normalizationPolicy,this.allowedModalities=const [InteractionModality.text],this.evaluationPolicyRef,this.storyActions=const [],this.evidenceMappings=const []});
}
final class AccessibleAlternativeDefinition { final String triggerCapability; final InteractionModality alternativeModality; final String storyEquivalence; final InteractionModality evidenceModality; const AccessibleAlternativeDefinition({required this.triggerCapability,required this.alternativeModality,required this.storyEquivalence,required this.evidenceModality}); }
final class LanguageHelpStep { final int step; final String textRef; const LanguageHelpStep({required this.step,required this.textRef}); }
final class HelpDefinition { final String? instructionRef; final String? strategyRef; final List<LanguageHelpStep> languageSteps; const HelpDefinition({this.instructionRef,this.strategyRef,this.languageSteps=const []}); }
enum ListeningResponseType { choice, text }
final class ListeningInteractionDefinition implements InteractionDefinition {
  @override final InteractionId interactionId; @override final String promptRef; @override final List<InteractionModality> allowedModalities; @override final String? evaluationPolicyRef; @override final List<StoryActionDefinition> storyActions; @override final List<EvidenceMappingDefinition> evidenceMappings; final String audioId; final ListeningResponseType responseType; final AccessibleAlternativeDefinition? accessibleAlternative; final HelpDefinition? help; @override InteractionType get type=>InteractionType.listening;
  const ListeningInteractionDefinition({required this.interactionId,required this.promptRef,required this.audioId,required this.responseType,this.accessibleAlternative,this.help,this.allowedModalities=const [InteractionModality.listening],this.evaluationPolicyRef,this.storyActions=const [],this.evidenceMappings=const []});
}
final class SpeechTargetDefinition { final String intentId; final String semanticValue; final List<String> acceptedForms; final List<String> languageObjectIds; const SpeechTargetDefinition({required this.intentId,required this.semanticValue,required this.acceptedForms,this.languageObjectIds=const []}); }
final class SpeechInteractionDefinition implements InteractionDefinition {
  @override final InteractionId interactionId; @override final String promptRef; @override final List<InteractionModality> allowedModalities; @override final String? evaluationPolicyRef; @override final List<StoryActionDefinition> storyActions; @override final List<EvidenceMappingDefinition> evidenceMappings; final String speechPolicyRef; final List<String> targetIntentIds; final List<SpeechTargetDefinition> targets; final bool textFallbackAllowed; final AccessibleAlternativeDefinition? accessibleAlternative; final HelpDefinition? help; @override InteractionType get type=>InteractionType.speech;
  const SpeechInteractionDefinition({required this.interactionId,required this.promptRef,required this.speechPolicyRef,required this.targetIntentIds,this.targets=const [],this.textFallbackAllowed=true,this.accessibleAlternative,this.help,this.allowedModalities=const [InteractionModality.speech,InteractionModality.text],this.evaluationPolicyRef,this.storyActions=const [],this.evidenceMappings=const []});
}
final class StoryActionDefinition { final StoryActionType type; final String? key; final String? value; final CharacterId? characterId; final String? factType; const StoryActionDefinition({required this.type,this.key,this.value,this.characterId,this.factType}); }
final class EvidenceMappingDefinition { final String competencyId; final String evidenceType; final List<InteractionModality> allowedModalities; const EvidenceMappingDefinition({required this.competencyId,required this.evidenceType,required this.allowedModalities}); }
final class NextSceneRule { final SceneCondition condition; final SceneId targetSceneId; final int priority; const NextSceneRule({required this.condition,required this.targetSceneId,this.priority=0}); }
final class SceneCondition { final SceneConditionType type; final String? key; final String? value; final CharacterId? characterId; final String? factType; const SceneCondition({required this.type,this.key,this.value,this.characterId,this.factType}); }
final class ContentPackage { final ContentManifest manifest; final JourneyDefinition journey; final Map<StageId,StageDefinition> stages; final Map<SceneId,SceneDefinition> scenes; final Map<InteractionId,InteractionDefinition> interactions; const ContentPackage({required this.manifest,required this.journey,required this.stages,required this.scenes,required this.interactions}); }
