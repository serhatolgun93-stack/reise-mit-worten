import '../../domain/content/content_models.dart';
import '../../domain/evidence/evidence_event.dart';

final class SemanticEvaluationResult {
  final EvidenceSemanticResult semanticResult;
  final String? semanticValue;
  final String? intentId;
  final List<String> languageObjectIds;
  const SemanticEvaluationResult({required this.semanticResult, this.semanticValue, this.intentId, this.languageObjectIds = const []});
}

final class GreekTextNormalizer {
  const GreekTextNormalizer();
  String normalize(String input) {
    var value = input.trim().toLowerCase();
    value = value.replaceAll(RegExp(r'''[.,!?;··«»“”'\"]'''), ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    const accents = {'ά':'α','έ':'ε','ή':'η','ί':'ι','ό':'ο','ύ':'υ','ώ':'ω','ΐ':'ι','ΰ':'υ'};
    for (final e in accents.entries) { value = value.replaceAll(e.key, e.value); }
    return value;
  }
}

final class ControlledSemanticEvaluator {
  final GreekTextNormalizer normalizer;
  const ControlledSemanticEvaluator({this.normalizer = const GreekTextNormalizer()});

  SemanticEvaluationResult evaluate({required String input, required List<SpeechTargetDefinition> targets}) {
    final normalized = normalizer.normalize(input);
    if (normalized.isEmpty) return const SemanticEvaluationResult(semanticResult: EvidenceSemanticResult.notDemonstrated);
    for (final target in targets) {
      for (final accepted in target.acceptedForms) {
        if (normalizer.normalize(accepted) == normalized) {
          return SemanticEvaluationResult(semanticResult: EvidenceSemanticResult.success, semanticValue: target.semanticValue, intentId: target.intentId, languageObjectIds: target.languageObjectIds);
        }
      }
    }
    return const SemanticEvaluationResult(semanticResult: EvidenceSemanticResult.notDemonstrated);
  }
}
