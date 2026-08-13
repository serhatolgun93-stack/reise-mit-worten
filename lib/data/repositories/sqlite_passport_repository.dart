import '../../domain/passport/passport_entry.dart';
import '../local/database/app_database.dart';

final class SqlitePassportRepository {
  final AppDatabase database;
  const SqlitePassportRepository(this.database);
  Future<PassportEntry?> get({required String localProfileId,required String journeyId}) async {
    final rows=await database.raw.query('passport_records',where:'local_profile_id = ? AND journey_id = ?',whereArgs:[localProfileId,journeyId],limit:1);
    if(rows.isEmpty)return null; final r=rows.first;
    return PassportEntry(localProfileId:r['local_profile_id'] as String,languageId:r['language_id'] as String,journeyId:r['journey_id'] as String,completedStageCount:r['completed_stage_count'] as int,totalStageCount:(r['total_stage_count'] as int?)??20,journeyStatus:r['journey_status'] as String,updatedAt:DateTime.parse(r['updated_at'] as String));
  }
}
