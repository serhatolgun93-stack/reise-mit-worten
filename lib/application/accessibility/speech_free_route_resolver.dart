import '../../domain/content/content_models.dart';

final class SpeechFreeRoute {
  final InteractionModality modality;
  final InteractionModality evidenceModality;
  final bool storyEquivalent;
  const SpeechFreeRoute({required this.modality, required this.evidenceModality, required this.storyEquivalent});
}

/// Resolves a declaratively-approved route when speech is disabled/unavailable.
/// It never fabricates SPEECH evidence for a fallback modality.
final class SpeechFreeRouteResolver {
  const SpeechFreeRouteResolver();

  SpeechFreeRoute? resolve(InteractionDefinition interaction) {
    if (interaction case SpeechInteractionDefinition speech) {
      final alt = speech.accessibleAlternative;
      if (alt != null && alt.alternativeModality != InteractionModality.speech) {
        return SpeechFreeRoute(
          modality: alt.alternativeModality,
          evidenceModality: alt.evidenceModality,
          storyEquivalent: alt.storyEquivalence.toUpperCase() == 'SAME',
        );
      }
      if (speech.textFallbackAllowed) {
        return const SpeechFreeRoute(
          modality: InteractionModality.text,
          evidenceModality: InteractionModality.text,
          storyEquivalent: true,
        );
      }
    }
    return null;
  }
}
