final class PassportEntry {
  final String localProfileId;
  final String languageId;
  final String journeyId;
  final int completedStageCount;
  final int totalStageCount;
  final String journeyStatus;
  final DateTime updatedAt;
  const PassportEntry({required this.localProfileId,required this.languageId,required this.journeyId,required this.completedStageCount,required this.totalStageCount,required this.journeyStatus,required this.updatedAt});
  bool get falselyClaimsCompletion => completedStageCount < totalStageCount && journeyStatus == 'completed';
}
