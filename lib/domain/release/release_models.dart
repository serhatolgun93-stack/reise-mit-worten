enum VerificationStatus { notRun, passed, failed, blocked }
enum DefectSeverity { blocker, critical, major, minor, cosmetic }
enum GateDecision { pass, noGo }
enum GoldenJourneyExecutionMode { automated, semiAutomated, manualRealDevice }

class TaskVerification {
  final String taskId;
  final VerificationStatus status;
  const TaskVerification(this.taskId, this.status);
}

class GoldenJourneyDefinition {
  final String id;
  final String title;
  final GoldenJourneyExecutionMode executionMode;
  final bool mandatory;
  const GoldenJourneyDefinition({
    required this.id,
    required this.title,
    required this.executionMode,
    this.mandatory = true,
  });
}

class GoldenJourneyResult {
  final String id;
  final VerificationStatus status;
  final String? note;
  const GoldenJourneyResult(this.id, this.status, {this.note});
}

class DefectSummary {
  final Map<DefectSeverity, int> counts;
  const DefectSummary(this.counts);
  int count(DefectSeverity severity) => counts[severity] ?? 0;
}

class ReleaseDomainGate {
  final String id;
  final VerificationStatus status;
  const ReleaseDomainGate(this.id, this.status);
}

class ReleaseGateInput {
  final List<TaskVerification> tasks;
  final List<GoldenJourneyResult> goldenJourneys;
  final DefectSummary defects;
  final List<ReleaseDomainGate> domainGates;
  const ReleaseGateInput({
    required this.tasks,
    required this.goldenJourneys,
    required this.defects,
    required this.domainGates,
  });
}

class ReleaseGateReport {
  final GateDecision decision;
  final List<String> blockers;
  final int tasksDone;
  final int tasksTotal;
  final int goldenJourneysPassed;
  final int goldenJourneysMandatory;
  const ReleaseGateReport({
    required this.decision,
    required this.blockers,
    required this.tasksDone,
    required this.tasksTotal,
    required this.goldenJourneysPassed,
    required this.goldenJourneysMandatory,
  });
}
