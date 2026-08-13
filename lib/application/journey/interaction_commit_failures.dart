sealed class InteractionCommitFailure implements Exception {
  final String code;
  final String message;
  const InteractionCommitFailure(this.code, this.message);

  @override
  String toString() => '$code: $message';
}

final class JourneyNotFoundFailure extends InteractionCommitFailure {
  const JourneyNotFoundFailure()
      : super('JOURNEY_NOT_FOUND', 'Journey instance was not found');
}

final class CheckpointNotFoundFailure extends InteractionCommitFailure {
  const CheckpointNotFoundFailure()
      : super('CHECKPOINT_NOT_FOUND', 'Journey checkpoint was not found');
}

final class StaleCheckpointFailure extends InteractionCommitFailure {
  const StaleCheckpointFailure()
      : super('STALE_CHECKPOINT', 'Checkpoint revision is no longer current');
}

final class InteractionCommitMismatchFailure extends InteractionCommitFailure {
  const InteractionCommitMismatchFailure()
      : super('COMMIT_MISMATCH', 'Commit id was reused for a different action');
}

final class InvalidCommitDraftFailure extends InteractionCommitFailure {
  const InvalidCommitDraftFailure(String detail)
      : super('INVALID_COMMIT_DRAFT', detail);
}
