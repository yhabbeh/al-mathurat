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

  // ========== Per-Item Progress Methods (Independent Counters) ==========

  /// Save progress for a specific item (independent counter)
  Future<void> saveItemProgress({
    required String categoryId,
    required int itemId,
    required int currentCount,
  }) async {
    await _dbHelper.saveItemProgress(
      categoryId: categoryId,
      itemId: itemId,
      currentCount: currentCount,
    );
  }

  /// Get today's count for a specific item
  Future<int> getItemProgress(String categoryId, int itemId) async {
    return await _dbHelper.getItemProgress(categoryId, itemId);
  }

  /// Get all items' progress for a category today (Map of itemId -> count)
  Future<Map<int, int>> getAllItemsProgress(String categoryId) async {
    return await _dbHelper.getAllItemsProgress(categoryId);
  }

  /// Mark category as completed and update stats
  Future<void> markCategoryCompleted(String categoryId) async {
    await _dbHelper.markCategoryCompleted(categoryId);
  }

  // ========== Legacy Methods ==========

  /// Load current progress for a category (legacy - for compatibility)
  Future<AthkarProgress?> loadCurrentProgress(String categoryId) async {
    return await _dbHelper.getCategoryProgress(categoryId);
  }

  /// Get all athkar progress
  Future<List<AthkarProgress>> getAllProgress() async {
    return await _dbHelper.getAllAthkarProgress();
  }
}
