import '../../domain/language_book/language_book_entry.dart';
import '../../domain/language_book/language_book_repository.dart';
import '../local/database/app_database.dart';

final class SqliteLanguageBookRepository implements LanguageBookRepository {
  final AppDatabase database;
  const SqliteLanguageBookRepository(this.database);

  @override
  Future<List<LanguageBookEntry>> getEntries({required String localProfileId, required String languageId}) async {
    final rows=await database.raw.query('language_book_projections',where:'local_profile_id = ? AND language_id = ?',whereArgs:[localProfileId,languageId],orderBy:'first_encountered_at ASC');
    return rows.map(_map).toList(growable:false);
  }
  @override
  Future<LanguageBookEntry?> getEntry({required String localProfileId, required String languageId, required String languageObjectId}) async {
    final rows=await database.raw.query('language_book_projections',where:'local_profile_id = ? AND language_id = ? AND language_object_id = ?',whereArgs:[localProfileId,languageId,languageObjectId],limit:1);
    return rows.isEmpty?null:_map(rows.first);
  }
  LanguageBookEntry _map(Map<String,Object?> row)=>LanguageBookEntry(
    localProfileId:row['local_profile_id'] as String, languageId:row['language_id'] as String, languageObjectId:row['language_object_id'] as String,
    visibility:LanguageBookVisibility.values.byName(row['visibility_state'] as String),
    firstEncounteredAt:DateTime.parse(row['first_encountered_at'] as String),
    lastEncounteredAt:DateTime.parse((row['last_encountered_at'] ?? row['first_encountered_at']) as String),
    firstAppliedAt:row['first_applied_at']==null?null:DateTime.parse(row['first_applied_at'] as String),
    lastAppliedAt:row['last_applied_at']==null?null:DateTime.parse(row['last_applied_at'] as String),
    lastModality:row['last_modality'] as String?, sourceJourneyId:row['source_journey_id'] as String?, sourceStageId:row['source_stage_id'] as String?);
}
