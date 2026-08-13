import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../core/id_generator/id_generator.dart';
import '../../core/time/clock.dart';
import '../../domain/artifact/artifact_snapshot.dart';

final class ArtifactSnapshotService {
  final IdGenerator idGenerator; final Clock clock;
  const ArtifactSnapshotService({required this.idGenerator,required this.clock});
  Future<ArtifactSnapshot> createCafeReceipt({required Transaction tx,required String journeyInstanceId,required String unlockEventId,required String itemId,required String sourceStageId}) async {
    const artifactId='EL.ATH.ART.CAFE_RECEIPT';
    final existing=await tx.query('artifact_snapshots',where:'journey_instance_id = ? AND artifact_id = ? AND unlock_event_id = ?',whereArgs:[journeyInstanceId,artifactId,unlockEventId],limit:1);
    if(existing.isNotEmpty)return _map(existing.first);
    final snapshot=ArtifactSnapshot(id:idGenerator.generate(),journeyInstanceId:journeyInstanceId,artifactId:artifactId,unlockEventId:unlockEventId,version:1,payload:{'item_id':itemId,'source_stage_id':sourceStageId},createdAt:clock.now().toUtc());
    await tx.insert('artifact_snapshots',{'artifact_snapshot_id':snapshot.id,'journey_instance_id':journeyInstanceId,'artifact_id':artifactId,'unlock_event_id':unlockEventId,'snapshot_version':1,'snapshot_payload':snapshot.encodePayload(),'created_at':snapshot.createdAt.toIso8601String()});
    return snapshot;
  }
  ArtifactSnapshot _map(Map<String,Object?> r)=>ArtifactSnapshot(id:r['artifact_snapshot_id'] as String,journeyInstanceId:r['journey_instance_id'] as String,artifactId:r['artifact_id'] as String,unlockEventId:r['unlock_event_id'] as String,version:r['snapshot_version'] as int,payload:(jsonDecode(r['snapshot_payload'] as String) as Map).cast<String,Object?>(),createdAt:DateTime.parse(r['created_at'] as String));
}
