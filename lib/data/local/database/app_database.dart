import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../migrations/migration_001_initial.dart';
import '../migrations/migration_002_story_event_source.dart';
import '../migrations/migration_003_evidence_provenance.dart';
import '../migrations/migration_004_personal_systems.dart';
import 'migration_runner.dart';

final class AppDatabase {
  static const schemaVersion = 4;

  final DatabaseFactory factory;
  final String? overridePath;
  Database? _database;

  AppDatabase({DatabaseFactory? factory, this.overridePath})
      : factory = factory ?? databaseFactory;

  Database get raw {
    final db = _database;
    if (db == null) throw StateError('Database is not open');
    return db;
  }

  Future<void> open() async {
    final path = overridePath ??
        p.join(await factory.getDatabasesPath(), 'reise_mit_worten.db');
    _database = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: schemaVersion,
        onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, version) async {
          await _runner.migrate(
            db: db,
            currentVersion: 0,
            targetVersion: version,
            appVersion: '0.7.0+7',
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          await _runner.migrate(
            db: db,
            currentVersion: oldVersion,
            targetVersion: newVersion,
            appVersion: '0.7.0+7',
          );
        },
      ),
    );
    await _healthCheck(raw);
  }

  MigrationRunner get _runner => const MigrationRunner([
        Migration001Initial(),
        Migration002StoryEventSource(),
        Migration003EvidenceProvenance(),
        Migration004PersonalSystems(),
      ]);

  Future<void> _healthCheck(Database db) async {
    const requiredTables = <String>{
      'local_profiles',
      'journey_instances',
      'journey_checkpoints',
      'interaction_commits',
      'story_events',
      'evidence_events',
      'character_knowledge',
    };
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    final found = rows.map((row) => row['name'] as String).toSet();
    final missing = requiredTables.difference(found);
    if (missing.isNotEmpty) {
      throw StateError('Database health check failed: missing $missing');
    }
  }

  Future<T> transaction<T>(Future<T> Function(Transaction tx) action) {
    return raw.transaction(action);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
