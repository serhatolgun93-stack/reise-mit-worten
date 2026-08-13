import '../../core/ids/journey_id.dart';
import '../../core/ids/journey_instance_id.dart';
import '../../core/ids/local_profile_id.dart';
import 'journey_status.dart';

final class JourneyInstance {
  final JourneyInstanceId id;
  final LocalProfileId localProfileId;
  final JourneyId journeyId;
  final JourneyStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;

  const JourneyInstance({
    required this.id,
    required this.localProfileId,
    required this.journeyId,
    required this.status,
    required this.startedAt,
    this.completedAt,
  });
}
