import 'language_book_entry.dart';

abstract interface class LanguageBookRepository {
  Future<List<LanguageBookEntry>> getEntries({required String localProfileId, required String languageId});
  Future<LanguageBookEntry?> getEntry({required String localProfileId, required String languageId, required String languageObjectId});
}
