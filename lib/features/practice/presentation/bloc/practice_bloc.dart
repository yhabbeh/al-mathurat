import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/practice_repository.dart';
import '../../data/repositories/practice_local_repository.dart';
import '../../data/models/athkar_model.dart'; // Add this import

part 'practice_event.dart';
part 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final PracticeRepository repository;
  final PracticeLocalRepository localRepository;

  PracticeBloc({required this.repository, required this.localRepository})
    : super(PracticeInitial()) {
    on<LoadPracticeData>(_onLoadPracticeData);
    on<IncrementCounter>(_onIncrementCounter);
    on<ResetCounter>(_onResetCounter);
    on<ToggleAudio>(_onToggleAudio);
    on<ChangeTab>(_onChangeTab);
  }

  Future<void> _onLoadPracticeData(
    LoadPracticeData event,
    Emitter<PracticeState> emit,
  ) async {
    emit(PracticeLoading());
    try {
      final data = await repository.loadAthkarData();
      // Find the category matching the requested categoryId
      final category = data.categories.firstWhere(
        (c) => c.id == event.categoryId,
        orElse: () => data.categories.isNotEmpty
            ? data.categories.first
            : throw Exception('No categories found'),
      );

      final items = category.items;
      if (items.isEmpty) throw Exception('No items in category');

      final initialIndex = 0;
      emit(
        PracticeLoaded(
          items: items,
          currentItem: items[initialIndex],
          currentCount: 0,
          isPlaying: false,
          activeTabIndex: initialIndex,
        ),
      );
    } catch (e) {
      // If asset loading fails, emit initial state
      // In production, this would be logged to a monitoring service
      emit(PracticeInitial());
    }
  }

  void _onIncrementCounter(
    IncrementCounter event,
    Emitter<PracticeState> emit,
  ) async {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      final target = currentState.targetCount;
      final newCount = currentState.currentCount + 1;

      // Save to database
      if (currentState.currentItem != null) {
        final isCompleted = newCount >= target;
        await localRepository.savePracticeSession(
          athkarId: currentState.currentItem!.text,
          count: newCount,
          isCompleted: isCompleted,
        );
      }

      // Check if completed and should advance to next
      if (newCount >= target) {
        final nextIndex = currentState.activeTabIndex + 1;

        // If there's a next item, advance to it
        if (nextIndex < currentState.items.length) {
          emit(currentState.copyWith(currentCount: newCount));

          // Small delay before advancing to show completion
          await Future.delayed(const Duration(milliseconds: 800));

          emit(
            currentState.copyWith(
              activeTabIndex: nextIndex,
              currentItem: currentState.items[nextIndex],
              currentCount: 0,
              isPlaying: false,
            ),
          );
        } else {
          // All items completed - stay on last one showing completed state
          emit(currentState.copyWith(currentCount: newCount));
        }
      } else {
        emit(currentState.copyWith(currentCount: newCount));
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
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      // Ensure index is valid
      if (event.tabIndex >= 0 && event.tabIndex < currentState.items.length) {
        emit(
          currentState.copyWith(
            activeTabIndex: event.tabIndex,
            currentItem: currentState.items[event.tabIndex],
            currentCount: 0, // Reset count on tab change
            isPlaying: false,
          ),
        );
      }
    }
  }
}
