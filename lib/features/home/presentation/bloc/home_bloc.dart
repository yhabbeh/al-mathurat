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

      // Determine greeting based on time of day
      final hour = DateTime.now().hour;
      String greeting;
      if (hour < 12) {
        greeting = 'صباح الخير';
      } else if (hour < 18) {
        greeting = 'مساء الخير';
      } else {
        greeting = 'مساء الخير';
      }

      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          greeting: greeting,
          quote: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
          surahName: 'سورة الرعد - آية 28',
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
