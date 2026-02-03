import '../../../../core/database/database_helper.dart';
import '../../../../core/database/models/database_models.dart';

class StatsLocalRepository {
  final DatabaseHelper _dbHelper;

  StatsLocalRepository(this._dbHelper);

  /// Get current user stats
  Future<UserStats> getUserStats() async {
    final stats = await _dbHelper.getUserStats();
    if (stats == null) {
      // Should not happen due to initial insert, but handle gracefully
      final defaultStats = UserStats(lastActiveDate: DateTime.now());
      return defaultStats;
    }
    return stats;
  }

  /// Update streak based on last active date
  Future<UserStats> updateStreak() async {
    final stats = await getUserStats();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      stats.lastActiveDate.year,
      stats.lastActiveDate.month,
      stats.lastActiveDate.day,
    );

    final daysDifference = today.difference(lastActive).inDays;

    int newCurrentStreak;
    int newLongestStreak = stats.longestStreak;

    if (daysDifference == 0) {
      // Same day, no change
      newCurrentStreak = stats.currentStreak;
    } else if (daysDifference == 1) {
      // Consecutive day, increment streak
      newCurrentStreak = stats.currentStreak + 1;
      if (newCurrentStreak > newLongestStreak) {
        newLongestStreak = newCurrentStreak;
      }
    } else {
      // Streak broken, reset to 1
      newCurrentStreak = 1;
    }

    final updatedStats = stats.copyWith(
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      lastActiveDate: now,
    );

    await _dbHelper.updateUserStats(updatedStats);
    return updatedStats;
  }

  /// Increment completed activities
  Future<UserStats> incrementActivity() async {
    final stats = await getUserStats();
    final updatedStats = stats.copyWith(
      completedActivities: stats.completedActivities + 1,
    );
    await _dbHelper.updateUserStats(updatedStats);
    return updatedStats;
  }

  /// Add practice minutes
  Future<UserStats> addMinutes(int minutes) async {
    final stats = await getUserStats();
    final updatedStats = stats.copyWith(
      totalMinutes: stats.totalMinutes + minutes,
    );
    await _dbHelper.updateUserStats(updatedStats);
    return updatedStats;
  }

  /// Complete an athkar session (updates streak and activity count)
  Future<UserStats> completeSession({int minutes = 5}) async {
    // Update streak first
    await updateStreak();

    // Increment activity
    await incrementActivity();

    // Add minutes and return final stats
    final finalStats = await addMinutes(minutes);

    return finalStats;
  }
}
