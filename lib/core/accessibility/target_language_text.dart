import 'package:flutter/material.dart';

/// Renders target-language text under the target locale so accessibility
/// services can select the appropriate pronunciation rules where supported.
final class TargetLanguageText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Locale locale;
  final TextAlign? textAlign;

  const TargetLanguageText({
    super.key,
    required this.text,
    this.style,
    this.locale = const Locale('el', 'GR'),
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) => Localizations.override(
    context: context,
    locale: locale,
    child: Semantics(
      label: text,
      child: Text(text, style: style, textAlign: textAlign),
    ),
  );
}
