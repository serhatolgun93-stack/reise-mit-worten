import 'package:sqflite/sqflite.dart';

import '../../domain/evidence/evidence_event.dart';

final class LanguageBookProjector {
  const LanguageBookProjector();

  Future<void> rebuild({
    required Transaction tx,
    required String localProfileId,
    required String languageId,
    required String journeyInstanceId,
    required String sourceJourneyId,
  }) async {
    await tx.delete('language_book_projections', where: 'local_profile_id = ? AND language_id = ?', whereArgs: [localProfileId, languageId]);
    final rows = await tx.query('evidence_events', where: 'journey_instance_id = ? AND language_object_id IS NOT NULL', whereArgs: [journeyInstanceId], orderBy: 'created_at ASC');
    final byObject=<String,List<Map<String,Object?>>>{};
    for(final row in rows){
      final id=row['language_object_id'] as String;
      byObject.putIfAbsent(id,()=>[]).add(row);
    }
    for(final entry in byObject.entries){
      final ev=entry.value;
      final first=DateTime.parse(ev.first['created_at'] as String);
      final last=DateTime.parse(ev.last['created_at'] as String);
      final apps=ev.where((r)=>(r['evidence_type'] as String?)==EvidenceType.application.name && (r['semantic_result'] as String?)==EvidenceSemanticResult.success.name).toList();
      final firstApplied=apps.isEmpty?null:DateTime.parse(apps.first['created_at'] as String);
      final lastApplied=apps.isEmpty?null:DateTime.parse(apps.last['created_at'] as String);
      await tx.insert('language_book_projections', {
        'local_profile_id':localProfileId,
        'language_id':languageId,
        'language_object_id':entry.key,
        'visibility_state':apps.isEmpty?'discovered':'active',
        'first_encountered_at':first.toUtc().toIso8601String(),
        'last_encountered_at':last.toUtc().toIso8601String(),
        'first_applied_at':firstApplied?.toUtc().toIso8601String(),
        'last_applied_at':lastApplied?.toUtc().toIso8601String(),
        'last_modality':apps.isEmpty?null:apps.last['modality'],
        'source_journey_id':sourceJourneyId,
        'source_stage_id':null,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
