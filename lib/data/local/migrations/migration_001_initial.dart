import 'package:sqflite/sqflite.dart';
import '../database/database_migration.dart';
final class Migration001Initial implements DatabaseMigration { const Migration001Initial(); @override int get fromVersion=>0; @override int get toVersion=>1; @override Future<void> apply(Transaction tx) async { for(final statement in _statements){ await tx.execute(statement); } }
static const _statements=<String>[
'''CREATE TABLE local_profiles (local_profile_id TEXT PRIMARY KEY, created_at TEXT NOT NULL, display_name TEXT NULL, ui_locale TEXT NOT NULL)''',
'''CREATE TABLE journey_instances (journey_instance_id TEXT PRIMARY KEY, local_profile_id TEXT NOT NULL, journey_id TEXT NOT NULL, status TEXT NOT NULL, started_at TEXT NOT NULL, completed_at TEXT NULL)''',
'''CREATE INDEX idx_journey_instances_profile ON journey_instances(local_profile_id)''',
'''CREATE TABLE journey_checkpoints (journey_instance_id TEXT PRIMARY KEY, stage_id TEXT NOT NULL, scene_id TEXT NOT NULL, interaction_id TEXT NOT NULL, revision INTEGER NOT NULL CHECK(revision >= 1), updated_at TEXT NOT NULL)''',
'''CREATE TABLE interaction_commits (interaction_commit_id TEXT PRIMARY KEY, journey_instance_id TEXT NOT NULL, interaction_id TEXT NOT NULL, checkpoint_revision_before INTEGER NOT NULL, created_at TEXT NOT NULL)''',
'''CREATE INDEX idx_interaction_commits_journey_interaction ON interaction_commits(journey_instance_id, interaction_id)''',
'''CREATE TABLE story_events (event_id TEXT PRIMARY KEY, interaction_commit_id TEXT NULL, journey_instance_id TEXT NOT NULL, sequence_number INTEGER NOT NULL, event_type TEXT NOT NULL, payload_version INTEGER NOT NULL, payload TEXT NOT NULL, content_version TEXT NOT NULL, created_at TEXT NOT NULL)''',
'''CREATE UNIQUE INDEX idx_story_sequence ON story_events(journey_instance_id, sequence_number)''',
'''CREATE TABLE story_value_projections (journey_instance_id TEXT NOT NULL, value_key TEXT NOT NULL, value_type TEXT NOT NULL, value_payload TEXT NOT NULL, source_event_id TEXT NOT NULL, updated_at TEXT NOT NULL, PRIMARY KEY (journey_instance_id, value_key))''',
'''CREATE TABLE character_knowledge (journey_instance_id TEXT NOT NULL, character_id TEXT NOT NULL, fact_type TEXT NOT NULL, value_ref TEXT NOT NULL, learned_from_event_id TEXT NOT NULL, learned_at TEXT NOT NULL, PRIMARY KEY (journey_instance_id, character_id, fact_type))''',
'''CREATE INDEX idx_character_knowledge_journey_character ON character_knowledge(journey_instance_id, character_id)''',
'''CREATE TABLE evidence_events (evidence_id TEXT PRIMARY KEY, interaction_commit_id TEXT NOT NULL, journey_instance_id TEXT NOT NULL, competency_id TEXT NOT NULL, interaction_id TEXT NOT NULL, content_version TEXT NOT NULL, modality TEXT NOT NULL, semantic_result TEXT NOT NULL, help_payload TEXT NOT NULL, created_at TEXT NOT NULL)''',
'''CREATE INDEX idx_evidence_competency ON evidence_events(journey_instance_id, competency_id)''',
'''CREATE TABLE language_book_projections (local_profile_id TEXT NOT NULL, language_id TEXT NOT NULL, language_object_id TEXT NOT NULL, visibility_state TEXT NOT NULL, first_encountered_at TEXT NOT NULL, last_used_at TEXT NULL, source_journey_id TEXT NULL, PRIMARY KEY (local_profile_id, language_id, language_object_id))''',
'''CREATE TABLE passport_records (local_profile_id TEXT NOT NULL, language_id TEXT NOT NULL, journey_id TEXT NOT NULL, completed_stage_count INTEGER NOT NULL, journey_status TEXT NOT NULL, updated_at TEXT NOT NULL, PRIMARY KEY (local_profile_id, journey_id))''',
'''CREATE TABLE artifact_snapshots (artifact_snapshot_id TEXT PRIMARY KEY, journey_instance_id TEXT NOT NULL, artifact_id TEXT NOT NULL, unlock_event_id TEXT NOT NULL, snapshot_version INTEGER NOT NULL, snapshot_payload TEXT NOT NULL, created_at TEXT NOT NULL)''',
'''CREATE TABLE installed_content_packages (package_id TEXT PRIMARY KEY, language_id TEXT NOT NULL, journey_id TEXT NOT NULL, package_version TEXT NOT NULL, contract_version INTEGER NOT NULL, installation_status TEXT NOT NULL, checksum TEXT NOT NULL, installed_at TEXT NULL)''',
'''CREATE TABLE app_settings (setting_key TEXT PRIMARY KEY, setting_value TEXT NOT NULL, updated_at TEXT NOT NULL)''',
'''CREATE TABLE migration_history (schema_version INTEGER PRIMARY KEY, applied_at TEXT NOT NULL, app_version TEXT NOT NULL)''']; }
