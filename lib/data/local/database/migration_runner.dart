import 'package:sqflite/sqflite.dart';

import 'database_migration.dart';

final class MigrationRunner {
  final List<DatabaseMigration> migrations;
  const MigrationRunner(this.migrations);

  Future<void> migrate({
    required Database db,
    required int currentVersion,
    required int targetVersion,
    required String appVersion,
  }) async {
    var version = currentVersion;
    while (version < targetVersion) {
      final matches = migrations.where((m) => m.fromVersion == version).toList();
      if (matches.length != 1) {
        throw StateError('Expected exactly one migration from schema $version');
      }
      final migration = matches.single;
      await db.transaction((tx) async {
        await migration.apply(tx);
        await tx.insert(
          'migration_history',
          {
            'schema_version': migration.toVersion,
            'applied_at': DateTime.now().toUtc().toIso8601String(),
            'app_version': appVersion,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await tx.execute('PRAGMA user_version = ${migration.toVersion}');
      });
      version = migration.toVersion;
    }
  }
}
