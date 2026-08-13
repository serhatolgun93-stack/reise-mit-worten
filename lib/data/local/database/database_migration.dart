import 'package:sqflite/sqflite.dart';

abstract interface class DatabaseMigration {
  int get fromVersion;
  int get toVersion;
  Future<void> apply(Transaction tx);
}
