import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/database/database_helper.dart';
import '../../../home/data/repositories/stats_local_repository.dart';

part 'journey_event.dart';
part 'journey_state.dart';

class JourneyBloc extends Bloc<JourneyEvent, JourneyState> {
  final StatsLocalRepository statsRepository;
  final DatabaseHelper dbHelper;

  JourneyBloc({required this.statsRepository, required this.dbHelper})
    : super(JourneyInitial()) {
    on<LoadJourneyData>(_onLoadJourneyData);
  }

  Future<void> _onLoadJourneyData(
    LoadJourneyData event,
    Emitter<JourneyState> emit,
  ) async {
    emit(JourneyLoading());
    try {
      // Load user stats from database
      final stats = await statsRepository.getUserStats();

      // Load athkar data from JSON
      final jsonString = await rootBundle.loadString(
        'assets/bundle/athkar.json',
      );
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final categoriesJson = jsonMap['categories'] as List<dynamic>;

      final List<CategoryModel> categories = [];

      for (final categoryJson in categoriesJson) {
        final id = categoryJson['id'] as String;
        final title = categoryJson['title'] as String;
        final items = categoryJson['items'] as List<dynamic>;
        final itemCount = items.length;

        // Get category-specific styling
        final styling = _getCategoryStyling(id);

        // Calculate today's progress for this category
        final todayProgress = await dbHelper.getCategoryProgress(id);
        double progressValue = 0.0;

        if (todayProgress != null && itemCount > 0) {
          // Calculate progress based on current item index and count
          final completedItems = todayProgress.currentItemIndex;
          final currentItemProgress =
              todayProgress.currentCount /
              (items[todayProgress.currentItemIndex]['repeat'] as int? ?? 1);
          progressValue = (completedItems + currentItemProgress) / itemCount;

          // If category was fully completed today
          if (todayProgress.completionsCount > 0) {
            progressValue = 1.0;
          }
        }

        categories.add(
          CategoryModel(
            id: id,
            title: title,
            subtitle: styling.subtitle,
            itemCount: '$itemCount ذكر',
            progress: progressValue.clamp(0.0, 1.0),
            colorValue: styling.colorValue,
            iconCodePoint: styling.iconCodePoint,
          ),
        );
      }

      emit(
        JourneyLoaded(
          categories: categories,
          streakDays: stats.currentStreak,
          completedSessions: stats.completedActivities,
          activityMinutes: stats.totalMinutes,
        ),
      );
    } catch (e) {
      emit(JourneyError('Failed to load journey data: $e'));
    }
  }

  /// Returns styling (subtitle, color, icon) based on category ID
  _CategoryStyling _getCategoryStyling(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return _CategoryStyling(
          subtitle: 'ابدأ يومك ببركة',
          colorValue: 0xFFF59E0B, // orange
          iconCodePoint: Icons.wb_sunny_outlined.codePoint,
        );
      case 'evening':
        return _CategoryStyling(
          subtitle: 'اختم يومك بذكر',
          colorValue: 0xFF8B5CF6, // purple
          iconCodePoint: Icons.nights_stay_outlined.codePoint,
        );
      case 'after_prayer':
        return _CategoryStyling(
          subtitle: 'أذكار ما بعد الصلاة',
          colorValue: 0xFF10B981, // green
          iconCodePoint: Icons.check_circle_outline.codePoint,
        );
      case 'sleep':
        return _CategoryStyling(
          subtitle: 'نم على ذكر الله',
          colorValue: 0xFF3B82F6, // blue
          iconCodePoint: Icons.bedtime_outlined.codePoint,
        );
      case 'wake_up':
        return _CategoryStyling(
          subtitle: 'استيقظ بحمد الله',
          colorValue: 0xFFEC4899, // pink
          iconCodePoint: Icons.alarm.codePoint,
        );
      default:
        return _CategoryStyling(
          subtitle: '',
          colorValue: 0xFF6B7280, // gray
          iconCodePoint: Icons.format_quote.codePoint,
        );
    }
  }
}

/// Helper class for category styling
class _CategoryStyling {
  final String subtitle;
  final int colorValue;
  final int iconCodePoint;

  const _CategoryStyling({
    required this.subtitle,
    required this.colorValue,
    required this.iconCodePoint,
  });
}
