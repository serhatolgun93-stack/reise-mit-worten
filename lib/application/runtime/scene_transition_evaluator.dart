import '../../core/ids/scene_id.dart';
import '../../domain/content/content_models.dart';

abstract interface class RuntimeConditionContext {
  Future<String?> storyValue(String key);
  Future<bool> eventOccurred(String eventType);
  Future<bool> characterKnows(String characterId, String factType);
  String? get lastInteractionResult;
}

final class SceneTransitionEvaluator {
  const SceneTransitionEvaluator();

  Future<SceneId?> resolve(SceneDefinition scene, RuntimeConditionContext context) async {
    final ordered = [...scene.nextSceneRules]..sort((a, b) => b.priority.compareTo(a.priority));
    SceneId? match;
    int? matchedPriority;
    for (final rule in ordered) {
      final applies = await _matches(rule.condition, context);
      if (!applies) continue;
      if (match != null && matchedPriority == rule.priority) {
        throw StateError('Ambiguous scene transition for ${scene.sceneId.value} at priority ${rule.priority}');
      }
      match ??= rule.targetSceneId;
      matchedPriority ??= rule.priority;
      if (matchedPriority != rule.priority) break;
    }
    return match;
  }

  Future<bool> _matches(SceneCondition condition, RuntimeConditionContext context) async => switch (condition.type) {
    SceneConditionType.always => true,
    SceneConditionType.storyValueEquals => (await context.storyValue(condition.key!)) == condition.value,
    SceneConditionType.eventOccurred => context.eventOccurred(condition.value!),
    SceneConditionType.characterKnows => context.characterKnows(condition.characterId!.value, condition.factType!),
    SceneConditionType.interactionResult => context.lastInteractionResult == condition.value,
  };
}
