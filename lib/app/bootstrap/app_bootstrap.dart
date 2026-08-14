import '../../core/id_generator/uuid_id_generator.dart';
import '../../core/time/system_clock.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/profile/local_profile_store.dart';
import '../environment/environment_config.dart';
import 'bootstrap_result.dart';
class AppBootstrap { Future<BootstrapResult> initialize() async { AppDatabase? database; try { final environment=EnvironmentConfig.resolve(); database=AppDatabase(); await database.open(); final profile=await LocalProfileStore(db:database.raw,idGenerator:UuidIdGenerator(),clock:SystemClock()).getOrCreate(); return BootstrapSuccess(environment:environment,database:database,localProfileId:profile.id); } catch (_) { await database?.close(); return const BootstrapFailure(errorCode:'BOOTSTRAP_DB_001',recoverable:true); } } }
