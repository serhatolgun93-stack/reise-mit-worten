import 'package:sqflite/sqflite.dart';
import '../../../core/id_generator/id_generator.dart';
import '../../../core/ids/local_profile_id.dart';
import '../../../core/time/clock.dart';
import '../../../domain/profile/local_profile.dart';
final class LocalProfileStore { final Database db; final IdGenerator idGenerator; final Clock clock; const LocalProfileStore({required this.db,required this.idGenerator,required this.clock}); Future<LocalProfile> getOrCreate({String uiLocale='de-DE'}) async { final rows=await db.query('local_profiles',limit:1); if(rows.isNotEmpty) return _fromRow(rows.first); final profile=LocalProfile(id:LocalProfileId(idGenerator.generate()),createdAt:clock.now(),uiLocale:uiLocale); await db.insert('local_profiles',{'local_profile_id':profile.id.value,'created_at':profile.createdAt.toUtc().toIso8601String(),'display_name':profile.displayName,'ui_locale':profile.uiLocale}); return profile; } LocalProfile _fromRow(Map<String,Object?> row)=>LocalProfile(id:LocalProfileId(row['local_profile_id']! as String),createdAt:DateTime.parse(row['created_at']! as String).toUtc(),displayName:row['display_name'] as String?,uiLocale:row['ui_locale']! as String); }
