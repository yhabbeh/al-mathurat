import '../../../../core/database/database_helper.dart';
import '../../../../core/database/models/database_models.dart';

class PracticeLocalRepository {
  final DatabaseHelper _dbHelper;

  PracticeLocalRepository(this._dbHelper);

  /// Save a practice session
  Future<int> savePracticeSession({
    required String athkarId,
    required int count,
    bool isCompleted = false,
  }) async {
    final session = PracticeSession(
      athkarId: athkarId,
      count: count,
      date: DateTime.now(),
      isCompleted: isCompleted,
    );
    return await _dbHelper.createPracticeSession(session);
  }

  /// Get practice sessions for a specific athkar
  Future<List<PracticeSession>> getPracticeSessions(String athkarId) async {
    return await _dbHelper.getPracticeSessions(athkarId: athkarId);
  }

  /// Get today's practice sessions
  Future<List<PracticeSession>> getTodaysSessions([String? athkarId]) async {
    return await _dbHelper.getPracticeSessions(
      athkarId: athkarId,
      date: DateTime.now(),
    );
  }

  /// Update a practice session
  Future<int> updateSession(PracticeSession session) async {
    return await _dbHelper.updatePracticeSession(session);
  }

  /// Track athkar progress
  Future<void> updateAthkarProgress({
    required String categoryId,
    required int itemId,
    required int completionsCount,
  }) async {
    final progress = AthkarProgress(
      categoryId: categoryId,
      itemId: itemId,
      completionsCount: completionsCount,
      lastCompleted: DateTime.now(),
    );
    await _dbHelper.createOrUpdateAthkarProgress(progress);
  }

  /// Get progress for specific athkar
  Future<AthkarProgress?> getAthkarProgress(
    String categoryId,
    int itemId,
  ) async {
    return await _dbHelper.getAthkarProgress(categoryId, itemId);
  }

  /// Get all athkar progress
  Future<List<AthkarProgress>> getAllProgress() async {
    return await _dbHelper.getAllAthkarProgress();
  }
}
