import 'package:flutter/material.dart';
import '../../../application/runtime/runtime_models.dart';

final class ListeningRenderer extends StatelessWidget {
  final ListeningViewModel model;
  final VoidCallback onAudioRequested;
  final VoidCallback? onAlternativeRequested;
  const ListeningRenderer({super.key, required this.model, required this.onAudioRequested, this.onAlternativeRequested});
  @override Widget build(BuildContext context) => Semantics(
    container: true,
    explicitChildNodes: true,
    label: 'Hörübung',
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(header: true, child: Text(model.prompt, style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(height: 16),
        Semantics(button: true, label: 'Audio abspielen', child: FilledButton.icon(onPressed: onAudioRequested, icon: const Icon(Icons.play_arrow), label: const Text('Audio abspielen'))),
        if (model.alternativeAvailable) ...[
          const SizedBox(height: 8),
          TextButton(onPressed: onAlternativeRequested, child: const Text('Textalternative verwenden')),
        ],
      ]),
    ),
  );
}
