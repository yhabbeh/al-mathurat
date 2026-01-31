import 'package:flutter/material.dart'; // Needed for Colors/Icons values access if we hardcode them here
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'journey_event.dart';
part 'journey_state.dart';

class JourneyBloc extends Bloc<JourneyEvent, JourneyState> {
  JourneyBloc() : super(JourneyInitial()) {
    on<LoadJourneyData>(_onLoadJourneyData);
  }

  Future<void> _onLoadJourneyData(
    LoadJourneyData event,
    Emitter<JourneyState> emit,
  ) async {
    emit(JourneyLoading());
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulating network

      final List<CategoryModel> mockCategories = [
        CategoryModel(
          id: '1',
          title: 'أذكار الصباح',
          subtitle: 'ابدأ يومك ببركة',
          itemCount: '33 ذكر',
          progress: 0.1,
          colorValue: 0xFFF59E0B, // orange
          iconCodePoint: Icons.wb_sunny_outlined.codePoint,
        ),
        CategoryModel(
          id: '2',
          title: 'الورد اليومي',
          subtitle: 'حافظ على استمرارك',
          itemCount: '5 صلوات',
          progress: 0.8,
          colorValue: 0xFF10B981, // green
          iconCodePoint: Icons.check_circle_outline.codePoint,
        ),
        CategoryModel(
          id: '3',
          title: 'دعاء السفر',
          subtitle: 'حفظك الله ورعاك',
          itemCount: '7 أدعية',
          progress: 0.0,
          colorValue: 0xFF3B82F6, // blue
          iconCodePoint: Icons.flight_takeoff.codePoint,
        ),
        CategoryModel(
          id: '4',
          title: 'أذكار المساء',
          subtitle: 'اختم يومك بذكر',
          itemCount: '33 ذكر',
          progress: 0.3,
          colorValue: 0xFF8B5CF6, // purple
          iconCodePoint: Icons.nights_stay_outlined.codePoint,
        ),
      ];

      emit(
        JourneyLoaded(
          categories: mockCategories,
          streakDays: 5,
          completedSessions: 124,
        ),
      );
    } catch (e) {
      emit(const JourneyError('Failed to load journey data'));
    }
  }
}
