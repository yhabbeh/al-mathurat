import 'package:equatable/equatable.dart';

/// Represents a practice session record
class PracticeSession extends Equatable {
  final int? id;
  final String athkarId;
  final int count;
  final DateTime date;
  final bool isCompleted;

  const PracticeSession({
    this.id,
    required this.athkarId,
    required this.count,
    required this.date,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'athkar_id': athkarId,
      'count': count,
      'date': date.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory PracticeSession.fromMap(Map<String, dynamic> map) {
    return PracticeSession(
      id: map['id'] as int?,
      athkarId: map['athkar_id'] as String,
      count: map['count'] as int,
      date: DateTime.parse(map['date'] as String),
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  PracticeSession copyWith({
    int? id,
    String? athkarId,
    int? count,
    DateTime? date,
    bool? isCompleted,
  }) {
    return PracticeSession(
      id: id ?? this.id,
      athkarId: athkarId ?? this.athkarId,
      count: count ?? this.count,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, athkarId, count, date, isCompleted];
}

/// Represents user statistics
class UserStats extends Equatable {
  final int? id;
  final int currentStreak;
  final int longestStreak;
  final int totalMinutes;
  final int completedActivities;
  final DateTime lastActiveDate;

  const UserStats({
    this.id,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalMinutes = 0,
    this.completedActivities = 0,
    required this.lastActiveDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'total_minutes': totalMinutes,
      'completed_activities': completedActivities,
      'last_active_date': lastActiveDate.toIso8601String(),
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      id: map['id'] as int?,
      currentStreak: map['current_streak'] as int,
      longestStreak: map['longest_streak'] as int,
      totalMinutes: map['total_minutes'] as int,
      completedActivities: map['completed_activities'] as int,
      lastActiveDate: DateTime.parse(map['last_active_date'] as String),
    );
  }

  UserStats copyWith({
    int? id,
    int? currentStreak,
    int? longestStreak,
    int? totalMinutes,
    int? completedActivities,
    DateTime? lastActiveDate,
  }) {
    return UserStats(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      completedActivities: completedActivities ?? this.completedActivities,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    currentStreak,
    longestStreak,
    totalMinutes,
    completedActivities,
    lastActiveDate,
  ];
}

/// Represents athkar completion progress (tracked per day)
class AthkarProgress extends Equatable {
  final int? id;
  final String categoryId;
  final int itemId;
  final int completionsCount;
  final DateTime? lastCompleted;
  final int currentCount;
  final int currentItemIndex;
  final String? date; // YYYY-MM-DD format for daily tracking

  const AthkarProgress({
    this.id,
    required this.categoryId,
    this.itemId = 0,
    this.completionsCount = 0,
    this.lastCompleted,
    this.currentCount = 0,
    this.currentItemIndex = 0,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'item_id': itemId,
      'completions_count': completionsCount,
      'last_completed': lastCompleted?.toIso8601String(),
      'current_count': currentCount,
      'current_item_index': currentItemIndex,
      'date': date,
    };
  }

  factory AthkarProgress.fromMap(Map<String, dynamic> map) {
    return AthkarProgress(
      id: map['id'] as int?,
      categoryId: map['category_id'] as String,
      itemId: map['item_id'] as int,
      completionsCount: map['completions_count'] as int,
      lastCompleted: map['last_completed'] != null
          ? DateTime.parse(map['last_completed'] as String)
          : null,
      currentCount: (map['current_count'] as int?) ?? 0,
      currentItemIndex: (map['current_item_index'] as int?) ?? 0,
      date: map['date'] as String?,
    );
  }

  AthkarProgress copyWith({
    int? id,
    String? categoryId,
    int? itemId,
    int? completionsCount,
    DateTime? lastCompleted,
    int? currentCount,
    int? currentItemIndex,
    String? date,
  }) {
    return AthkarProgress(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      itemId: itemId ?? this.itemId,
      completionsCount: completionsCount ?? this.completionsCount,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      currentCount: currentCount ?? this.currentCount,
      currentItemIndex: currentItemIndex ?? this.currentItemIndex,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    itemId,
    completionsCount,
    lastCompleted,
    currentCount,
    currentItemIndex,
    date,
  ];
}
