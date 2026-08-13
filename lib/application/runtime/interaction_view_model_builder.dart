import '../../domain/content/content_models.dart';
import 'runtime_models.dart';

abstract interface class ContentTextResolver {
  String resolve(String ref);
}

final class MapContentTextResolver implements ContentTextResolver {
  final Map<String, String> values;
  const MapContentTextResolver(this.values);
  @override String resolve(String ref) => values[ref] ?? ref;
}

final class InteractionViewModelBuilder {
  final ContentTextResolver textResolver;
  const InteractionViewModelBuilder(this.textResolver);

  InteractionViewModel build(InteractionDefinition definition) {
    return switch (definition) {
      DialogueInteractionDefinition d => DialogueViewModel(
          interactionId: d.interactionId.value,
          speakerName: d.speakerId.value,
          text: textResolver.resolve(d.textRef),
          audioId: d.audioRef,
        ),
      ChoiceInteractionDefinition c => ChoiceViewModel(
          interactionId: c.interactionId.value,
          prompt: textResolver.resolve(c.promptRef),
          options: c.options.map((o) => ChoiceOptionViewModel(id: o.optionId, label: textResolver.resolve(o.labelRef), semanticValue: o.semanticValue)).toList(growable: false),
          confirmationRequired: c.confirmationRequired,
        ),
      TextInputInteractionDefinition t => TextInputViewModel(
          interactionId: t.interactionId.value,
          prompt: textResolver.resolve(t.promptRef),
          inputType: t.inputType,
          maxLength: t.maxLength,
          keyboardLocaleHint: t.inputType == TextInputType.targetLanguageText ? 'el-GR' : 'de-DE',
        ),
      ListeningInteractionDefinition l => ListeningViewModel(
          interactionId: l.interactionId.value,
          prompt: textResolver.resolve(l.promptRef),
          audioId: l.audioId,
          responseType: l.responseType,
          alternativeAvailable: l.accessibleAlternative != null,
        ),
      SpeechInteractionDefinition sp => SpeechViewModel(
          interactionId: sp.interactionId.value,
          prompt: textResolver.resolve(sp.promptRef),
          state: SpeechShellState.ready,
          textFallbackAvailable: sp.textFallbackAllowed,
          helpAvailable: sp.help != null,
        ),
    };
  }
}
