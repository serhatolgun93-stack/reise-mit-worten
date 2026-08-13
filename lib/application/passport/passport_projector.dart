import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../domain/story/story_event_payloads.dart';

final class PassportProjector {
  const PassportProjector();
  Future<void> rebuild({required Transaction tx,required String localProfileId,required String languageId,required String journeyId,required String journeyInstanceId,required int totalStageCount}) async {
    final events=await tx.query('story_events',where:'journey_instance_id = ?',whereArgs:[journeyInstanceId],orderBy:'sequence_number ASC');
    final completed=<String>{};
    for(final e in events){
      if(e['event_type']==StoryEventTypes.stageCompleted){
        final payload=jsonDecode(e['payload'] as String) as Map<String,dynamic>;
        final stage=payload['stage_id'] as String?;
        if(stage!=null) completed.add(stage);
      }
    }
    await tx.insert('passport_records',{
      'local_profile_id':localProfileId,'language_id':languageId,'journey_id':journeyId,
      'completed_stage_count':completed.length,'total_stage_count':totalStageCount,
      'journey_status':completed.length>=totalStageCount?'completed':'active','updated_at':DateTime.now().toUtc().toIso8601String(),
    },conflictAlgorithm:ConflictAlgorithm.replace);
  }
}
