import '../models/codex_entry.dart';

abstract interface class CodexRepository {
  Future<List<CodexEntry>> fetchCharacters({required String userId});
}
