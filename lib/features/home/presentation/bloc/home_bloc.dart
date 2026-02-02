import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeState.loading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          greeting: 'مساء الخير',
          quote: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
          surahName: 'سورة الرعد - آية 28',
          activityMinutes: 45,
          completedActivities: 3,
          streakDays: 5,
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
