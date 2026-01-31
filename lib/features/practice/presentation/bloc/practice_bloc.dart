import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'practice_event.dart';
part 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  PracticeBloc() : super(PracticeInitial()) {
    on<LoadPracticeData>(_onLoadPracticeData);
    on<IncrementCounter>(_onIncrementCounter);
    on<ResetCounter>(_onResetCounter);
    on<ToggleAudio>(_onToggleAudio);
    on<ChangeTab>(_onChangeTab);
  }

  void _onLoadPracticeData(
    LoadPracticeData event,
    Emitter<PracticeState> emit,
  ) {
    emit(
      const PracticeLoaded(
        currentCount: 0,
        targetCount: 33,
        label: 'سُبْحَانَ اللَّهِ',
        isPlaying: false,
        activeTabIndex: 0,
      ),
    );
  }

  void _onIncrementCounter(
    IncrementCounter event,
    Emitter<PracticeState> emit,
  ) {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      if (currentState.currentCount < currentState.targetCount) {
        emit(
          currentState.copyWith(currentCount: currentState.currentCount + 1),
        );
      } else {
        // Loop or finish? For now, just reset or stay max.
        // Let's reset to simulate loop.
        emit(
          currentState.copyWith(currentCount: 1),
        ); // Reset to 1 explicitly or 0? 1 feels better for flow
      }
    }
  }

  void _onResetCounter(ResetCounter event, Emitter<PracticeState> emit) {
    if (state is PracticeLoaded) {
      emit((state as PracticeLoaded).copyWith(currentCount: 0));
    }
  }

  void _onToggleAudio(ToggleAudio event, Emitter<PracticeState> emit) {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      emit(currentState.copyWith(isPlaying: !currentState.isPlaying));
    }
  }

  void _onChangeTab(ChangeTab event, Emitter<PracticeState> emit) {
    // Switch logic
    String newLabel;
    int newTarget;

    switch (event.tabIndex) {
      case 0:
        newLabel = 'سُبْحَانَ اللَّهِ';
        newTarget = 33;
        break;
      case 1:
        newLabel = 'الْحَمْدُ لِلَّهِ';
        newTarget = 33;
        break;
      case 2:
        newLabel = 'اللَّهُ أَكْبَرُ';
        newTarget = 34; // Often 34 for takbir in sequence
        break;
      default:
        newLabel = 'ذكر';
        newTarget = 33;
    }

    emit(
      PracticeLoaded(
        currentCount: 0,
        targetCount: newTarget,
        label: newLabel,
        isPlaying: false,
        activeTabIndex: event.tabIndex,
      ),
    );
  }
}
