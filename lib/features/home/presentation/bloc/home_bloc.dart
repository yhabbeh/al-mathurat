import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/stats_local_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StatsLocalRepository statsRepository;

  HomeBloc({required this.statsRepository}) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeState.loading());

    try {
      // Load real stats from database
      final stats = await statsRepository.getUserStats();

      // Load random verse
      String quote = 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ';
      String surahName = 'سورة الرعد - آية 28';
      int currentSurahNumber = 13;
      int currentVerseNumber = 28;

      try {
        final random = Random();
        final surahNumber = random.nextInt(114) + 1;
        final jsonString = await rootBundle.loadString(
          'assets/bundle/quraan/surah/surah_$surahNumber.json',
        );
        final data = json.decode(jsonString);

        final surahArName = data['name']['ar'];
        final verses = data['verses'] as List;
        final randomVerseIndex = random.nextInt(verses.length);
        final verse = verses[randomVerseIndex];

        quote = verse['text']['ar'];
        final verseNumber = verse['number'];
        surahName = 'سورة $surahArName - آية $verseNumber';
        currentSurahNumber = surahNumber;
        currentVerseNumber = verseNumber;
      } catch (e) {
        // Fallback to default if anything fails
        print('Error loading random verse: $e');
      }

      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          quote: quote,
          surahName: surahName,
          surahNumber: currentSurahNumber,
          verseNumber: currentVerseNumber,
          activityMinutes: stats.totalMinutes,
          completedActivities: stats.completedActivities,
          streakDays: stats.currentStreak,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Failed to load home data',
        ),
      );
    }
  }
}
