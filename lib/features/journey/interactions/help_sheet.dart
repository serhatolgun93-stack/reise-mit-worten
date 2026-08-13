import 'package:flutter/material.dart';
import '../../../application/runtime/runtime_models.dart';

final class HelpSheet extends StatelessWidget {
  final HelpViewModel model;
  final ValueChanged<String> onHelpUsed;
  const HelpSheet({super.key, required this.model, required this.onHelpUsed});
  @override Widget build(BuildContext context) => Semantics(
    scopesRoute: true,
    namesRoute: true,
    label: 'Hilfe',
    child: SafeArea(child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(24), children: [
      Semantics(header: true, child: Text('Hilfe', style: Theme.of(context).textTheme.headlineSmall)),
      if (model.instruction != null) ListTile(title: const Text('Aufgabe noch einmal'), subtitle: Text(model.instruction!), onTap: () => onHelpUsed('INSTRUCTION')),
      if (model.strategy != null) ListTile(title: const Text('Hinweis'), subtitle: Text(model.strategy!), onTap: () => onHelpUsed('STRATEGY')),
      for (var i = 0; i < model.languageSteps.length; i++) ListTile(title: Text('Sprachhilfe ${i + 1}'), subtitle: Text(model.languageSteps[i]), onTap: () => onHelpUsed('LANGUAGE_${i + 1}')),
      const SizedBox(height: 8),
      TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Schließen')),
    ])),
  );
}
