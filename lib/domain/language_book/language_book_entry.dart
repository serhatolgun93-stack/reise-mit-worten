enum LanguageBookVisibility { discovered, active }

final class LanguageBookEntry {
  final String localProfileId;
  final String languageId;
  final String languageObjectId;
  final LanguageBookVisibility visibility;
  final DateTime firstEncounteredAt;
  final DateTime lastEncounteredAt;
  final DateTime? firstAppliedAt;
  final DateTime? lastAppliedAt;
  final String? lastModality;
  final String? sourceJourneyId;
  final String? sourceStageId;

  const LanguageBookEntry({
    required this.localProfileId,
    required this.languageId,
    required this.languageObjectId,
    required this.visibility,
    required this.firstEncounteredAt,
    required this.lastEncounteredAt,
    this.firstAppliedAt,
    this.lastAppliedAt,
    this.lastModality,
    this.sourceJourneyId,
    this.sourceStageId,
  });

  bool get hasBeenApplied => firstAppliedAt != null;
  bool get hasBeenSpoken => lastModality == 'speech';
}
