import 'package:sqflite/sqflite.dart';
import '../database/database_migration.dart';

final class Migration003EvidenceProvenance implements DatabaseMigration {
  const Migration003EvidenceProvenance();
  @override int get fromVersion => 2;
  @override int get toVersion => 3;
  @override Future<void> apply(Transaction tx) async {
    await tx.execute("ALTER TABLE evidence_events ADD COLUMN evidence_type TEXT NOT NULL DEFAULT 'application'");
    await tx.execute('ALTER TABLE evidence_events ADD COLUMN language_object_id TEXT NULL');
    await tx.execute('CREATE INDEX idx_evidence_language_object ON evidence_events(journey_instance_id, language_object_id)');
  }
}
