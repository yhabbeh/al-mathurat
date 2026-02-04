import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/database_models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('almaathorat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Get today's date as a string for database queries
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add current_count and current_item_index columns to athkar_progress
      await db.execute(
        'ALTER TABLE athkar_progress ADD COLUMN current_count INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE athkar_progress ADD COLUMN current_item_index INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 3) {
      // Add date column for daily progress tracking
      await db.execute('ALTER TABLE athkar_progress ADD COLUMN date TEXT');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // Practice Sessions table
    await db.execute('''
      CREATE TABLE practice_sessions (
        id $idType,
        athkar_id $textType,
        count $intType,
        date $textType,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // User Stats table
    await db.execute('''
      CREATE TABLE user_stats (
        id $idType,
        current_streak $intType DEFAULT 0,
        longest_streak $intType DEFAULT 0,
        total_minutes $intType DEFAULT 0,
        completed_activities $intType DEFAULT 0,
        last_active_date $textType
      )
    ''');

    // Athkar Progress table (with current progress tracking per day)
    await db.execute('''
      CREATE TABLE athkar_progress (
        id $idType,
        category_id $textType,
        item_id $intType,
        completions_count $intType DEFAULT 0,
        last_completed TEXT,
        current_count $intType DEFAULT 0,
        current_item_index $intType DEFAULT 0,
        date TEXT
      )
    ''');

    // Insert initial user stats
    await db.insert('user_stats', {
      'current_streak': 0,
      'longest_streak': 0,
      'total_minutes': 0,
      'completed_activities': 0,
      'last_active_date': DateTime.now().toIso8601String(),
    });
  }

  // Practice Sessions CRUD
  Future<int> createPracticeSession(PracticeSession session) async {
    final db = await database;
    return await db.insert('practice_sessions', session.toMap());
  }

  Future<List<PracticeSession>> getPracticeSessions({
    String? athkarId,
    DateTime? date,
  }) async {
    final db = await database;

    String where = '';
    List<dynamic> whereArgs = [];

    if (athkarId != null) {
      where = 'athkar_id = ?';
      whereArgs.add(athkarId);
    }

    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      if (where.isNotEmpty) where += ' AND ';
      where += 'date >= ? AND date < ?';
      whereArgs.addAll([
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ]);
    }

    final maps = await db.query(
      'practice_sessions',
      where: where.isNotEmpty ? where : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'date DESC',
    );

    return maps.map((map) => PracticeSession.fromMap(map)).toList();
  }

  Future<int> updatePracticeSession(PracticeSession session) async {
    final db = await database;
    return await db.update(
      'practice_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  // User Stats CRUD
  Future<UserStats?> getUserStats() async {
    final db = await database;
    final maps = await db.query('user_stats', limit: 1);

    if (maps.isEmpty) return null;
    return UserStats.fromMap(maps.first);
  }

  Future<int> updateUserStats(UserStats stats) async {
    final db = await database;
    return await db.update(
      'user_stats',
      stats.toMap(),
      where: 'id = ?',
      whereArgs: [stats.id],
    );
  }

  Future<int> incrementCompletedActivities() async {
    final stats = await getUserStats();
    if (stats == null) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      stats.lastActiveDate.year,
      stats.lastActiveDate.month,
      stats.lastActiveDate.day,
    );

    int newStreak = stats.currentStreak;

    // Check if this is a new day
    if (today.isAfter(lastActive)) {
      final daysDifference = today.difference(lastActive).inDays;
      if (daysDifference == 1) {
        // Consecutive day - increment streak
        newStreak = stats.currentStreak + 1;
      } else if (daysDifference > 1) {
        // Missed days - reset streak
        newStreak = 1;
      }
    } else if (stats.currentStreak == 0) {
      // First activity ever
      newStreak = 1;
    }

    final updatedStats = stats.copyWith(
      completedActivities: stats.completedActivities + 1,
      currentStreak: newStreak,
      longestStreak: newStreak > stats.longestStreak
          ? newStreak
          : stats.longestStreak,
      lastActiveDate: now,
    );

    return await updateUserStats(updatedStats);
  }

  // Athkar Progress CRUD - tracks per-item per-day (independent counters)

  /// Save progress for a specific item on a specific day
  Future<int> saveItemProgress({
    required String categoryId,
    required int itemId,
    required int currentCount,
  }) async {
    final db = await database;
    final today = _getTodayDateString();

    print(
      '🔷 [DB] saveItemProgress: cat=$categoryId, item=$itemId, count=$currentCount, date=$today',
    );

    // Query for today's record for this specific item
    final existing = await db.query(
      'athkar_progress',
      where: 'category_id = ? AND item_id = ? AND date = ?',
      whereArgs: [categoryId, itemId, today],
    );

    print('🔷 [DB] Existing records: ${existing.length}');

    if (existing.isEmpty) {
      final id = await db.insert('athkar_progress', {
        'category_id': categoryId,
        'item_id': itemId,
        'current_count': currentCount,
        'current_item_index': itemId,
        'completions_count': 0,
        'date': today,
      });
      print('🔷 [DB] Inserted new record with id=$id');
      return id;
    } else {
      final updated = await db.update(
        'athkar_progress',
        {'current_count': currentCount},
        where: 'category_id = ? AND item_id = ? AND date = ?',
        whereArgs: [categoryId, itemId, today],
      );
      print('🔷 [DB] Updated $updated record(s)');
      return updated;
    }
  }

  /// Get today's count for a specific item
  Future<int> getItemProgress(String categoryId, int itemId) async {
    final db = await database;
    final today = _getTodayDateString();

    final maps = await db.query(
      'athkar_progress',
      columns: ['current_count'],
      where: 'category_id = ? AND item_id = ? AND date = ?',
      whereArgs: [categoryId, itemId, today],
    );

    if (maps.isEmpty) return 0;
    return (maps.first['current_count'] as int?) ?? 0;
  }

  /// Get all items' progress for a category today
  Future<Map<int, int>> getAllItemsProgress(String categoryId) async {
    final db = await database;
    final today = _getTodayDateString();

    print('🔷 [DB] getAllItemsProgress: cat=$categoryId, date=$today');

    final maps = await db.query(
      'athkar_progress',
      columns: ['item_id', 'current_count'],
      where: 'category_id = ? AND date = ?',
      whereArgs: [categoryId, today],
    );

    print('🔷 [DB] Found ${maps.length} records');

    final result = <int, int>{};
    for (final map in maps) {
      final itemId = map['item_id'] as int;
      final count = (map['current_count'] as int?) ?? 0;
      result[itemId] = count;
    }
    print('🔷 [DB] Returning progress: $result');
    return result;
  }

  /// Mark a category as fully completed today
  Future<void> markCategoryCompleted(String categoryId) async {
    final db = await database;
    final today = _getTodayDateString();

    // Update the first item's record to track category completion
    await db.rawUpdate(
      '''
      UPDATE athkar_progress 
      SET completions_count = completions_count + 1, last_completed = ?
      WHERE category_id = ? AND date = ? AND item_id = 0
    ''',
      [DateTime.now().toIso8601String(), categoryId, today],
    );

    // Also increment completed activities in user stats
    await incrementCompletedActivities();
  }

  /// Legacy method - Get today's progress for a category (first item)
  Future<AthkarProgress?> getCategoryProgress(String categoryId) async {
    final db = await database;
    final today = _getTodayDateString();

    final maps = await db.query(
      'athkar_progress',
      where: 'category_id = ? AND date = ?',
      whereArgs: [categoryId, today],
      orderBy: 'item_id ASC',
    );

    if (maps.isEmpty) return null;
    return AthkarProgress.fromMap(maps.first);
  }

  /// Get all-time completions count for a category
  Future<int> getCategoryTotalCompletions(String categoryId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(completions_count) as total FROM athkar_progress WHERE category_id = ?',
      [categoryId],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  /// Check if category was completed today
  Future<bool> isCategoryCompletedToday(String categoryId) async {
    final db = await database;
    final today = _getTodayDateString();

    final maps = await db.query(
      'athkar_progress',
      where: 'category_id = ? AND date = ? AND completions_count > 0',
      whereArgs: [categoryId, today],
    );
    return maps.isNotEmpty;
  }

  Future<List<AthkarProgress>> getAllAthkarProgress() async {
    final db = await database;
    final maps = await db.query('athkar_progress');
    return maps.map((map) => AthkarProgress.fromMap(map)).toList();
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
