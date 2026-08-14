import '../../core/ids/local_profile_id.dart';
import '../../data/local/database/app_database.dart';
import '../environment/environment_config.dart';
sealed class BootstrapResult { const BootstrapResult(); }
final class BootstrapSuccess extends BootstrapResult { final EnvironmentConfig environment; final AppDatabase database; final LocalProfileId localProfileId; const BootstrapSuccess({required this.environment,required this.database,required this.localProfileId}); }
final class BootstrapFailure extends BootstrapResult { final String errorCode; final bool recoverable; const BootstrapFailure({required this.errorCode,required this.recoverable}); }
