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

    return await openDatabase(path, version: 1, onCreate: _createDB);
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

    // Athkar Progress table
    await db.execute('''
      CREATE TABLE athkar_progress (
        id $idType,
        category_id $textType,
        item_id $intType,
        completions_count $intType DEFAULT 0,
        last_completed TEXT
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

  // Athkar Progress CRUD
  Future<int> createOrUpdateAthkarProgress(AthkarProgress progress) async {
    final db = await database;

    final existing = await db.query(
      'athkar_progress',
      where: 'category_id = ? AND item_id = ?',
      whereArgs: [progress.categoryId, progress.itemId],
    );

    if (existing.isEmpty) {
      return await db.insert('athkar_progress', progress.toMap());
    } else {
      return await db.update(
        'athkar_progress',
        progress.toMap(),
        where: 'category_id = ? AND item_id = ?',
        whereArgs: [progress.categoryId, progress.itemId],
      );
    }
  }

  Future<AthkarProgress?> getAthkarProgress(
    String categoryId,
    int itemId,
  ) async {
    final db = await database;
    final maps = await db.query(
      'athkar_progress',
      where: 'category_id = ? AND item_id = ?',
      whereArgs: [categoryId, itemId],
    );

    if (maps.isEmpty) return null;
    return AthkarProgress.fromMap(maps.first);
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
