import '../../core/ids/character_id.dart';
import '../../core/ids/competency_id.dart';
import '../../core/ids/interaction_commit_id.dart';
import '../../core/ids/interaction_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../core/ids/scene_id.dart';
import '../../core/ids/stage_id.dart';
import '../../domain/evidence/evidence_event.dart';

final class StoryEventDraft {
  final String eventType;
  final String payload;
  final int payloadVersion;
  final String contentVersion;

  const StoryEventDraft({
    required this.eventType,
    required this.payload,
    required this.contentVersion,
    this.payloadVersion = 1,
  });
}

final class EvidenceEventDraft {
  final CompetencyId competencyId;
  final String contentVersion;
  final EvidenceModality modality;
  final EvidenceSemanticResult semanticResult;
  final String helpPayload;
  final EvidenceType evidenceType;
  final String? languageObjectId;

  const EvidenceEventDraft({
    required this.competencyId,
    required this.contentVersion,
    required this.modality,
    required this.semanticResult,
    this.helpPayload = '{}',
    this.evidenceType = EvidenceType.application,
    this.languageObjectId,
  });
}

final class StoryValueChange {
  final String key;
  final String type;
  final String payload;
  final int sourceStoryEventIndex;

  const StoryValueChange({
    required this.key,
    required this.type,
    required this.payload,
    required this.sourceStoryEventIndex,
  });
}

final class CharacterKnowledgeChange {
  final CharacterId characterId;
  final String factType;
  final String valueRef;
  final int sourceStoryEventIndex;

  const CharacterKnowledgeChange({
    required this.characterId,
    required this.factType,
    required this.valueRef,
    required this.sourceStoryEventIndex,
  });
}

final class NextCheckpointDraft {
  final StageId stageId;
  final SceneId sceneId;
  final InteractionId interactionId;

  const NextCheckpointDraft({
    required this.stageId,
    required this.sceneId,
    required this.interactionId,
  });
}

final class InteractionCommitCommand {
  final InteractionCommitId commitId;
  final JourneyInstanceId journeyInstanceId;
  final InteractionId interactionId;
  final int checkpointRevision;
  final List<StoryEventDraft> storyEvents;
  final List<EvidenceEventDraft> evidenceEvents;
  final List<StoryValueChange> storyValueChanges;
  final List<CharacterKnowledgeChange> knowledgeChanges;
  final NextCheckpointDraft nextCheckpoint;

  const InteractionCommitCommand({
    required this.commitId,
    required this.journeyInstanceId,
    required this.interactionId,
    required this.checkpointRevision,
    required this.nextCheckpoint,
    this.storyEvents = const [],
    this.evidenceEvents = const [],
    this.storyValueChanges = const [],
    this.knowledgeChanges = const [],
  });
}

final class InteractionCommitResult {
  final InteractionCommitId commitId;
  final int checkpointRevisionAfter;
  final bool wasIdempotentReplay;

  const InteractionCommitResult({
    required this.commitId,
    required this.checkpointRevisionAfter,
    required this.wasIdempotentReplay,
  });
}
