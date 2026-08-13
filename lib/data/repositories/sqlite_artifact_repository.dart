import 'dart:convert';
import '../../domain/artifact/artifact_snapshot.dart';
import '../local/database/app_database.dart';

final class SqliteArtifactRepository {
  final AppDatabase database;
  const SqliteArtifactRepository(this.database);
  Future<List<ArtifactSnapshot>> getForJourney(String journeyInstanceId) async {
    final rows=await database.raw.query('artifact_snapshots',where:'journey_instance_id = ?',whereArgs:[journeyInstanceId],orderBy:'created_at ASC');
    return rows.map((r)=>ArtifactSnapshot(id:r['artifact_snapshot_id'] as String,journeyInstanceId:r['journey_instance_id'] as String,artifactId:r['artifact_id'] as String,unlockEventId:r['unlock_event_id'] as String,version:r['snapshot_version'] as int,payload:(jsonDecode(r['snapshot_payload'] as String) as Map).cast<String,Object?>(),createdAt:DateTime.parse(r['created_at'] as String))).toList(growable:false);
  }
}
