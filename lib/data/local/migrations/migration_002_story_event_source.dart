import 'package:sqflite/sqflite.dart';

import '../database/database_migration.dart';

final class Migration002StoryEventSource implements DatabaseMigration {
  const Migration002StoryEventSource();

  @override
  int get fromVersion => 1;

  @override
  int get toVersion => 2;

  @override
  Future<void> apply(Transaction tx) async {
    await tx.execute(
      'ALTER TABLE story_events ADD COLUMN source_interaction_id TEXT NULL',
    );
  }
}
