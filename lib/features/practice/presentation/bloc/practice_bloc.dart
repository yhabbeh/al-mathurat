import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/practice_repository.dart';
import '../../data/repositories/practice_local_repository.dart';
import '../../data/models/athkar_model.dart';

part 'practice_event.dart';
part 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final PracticeRepository repository;
  final PracticeLocalRepository localRepository;

  // Cache of all items' progress for the current category
  Map<int, int> _itemsProgress = {};

  PracticeBloc({required this.repository, required this.localRepository})
    : super(PracticeInitial()) {
    on<LoadPracticeData>(_onLoadPracticeData);
    on<IncrementCounter>(_onIncrementCounter);
    on<ResetCounter>(_onResetCounter);
    on<ToggleAudio>(_onToggleAudio);
    on<ChangeTab>(_onChangeTab);
    on<SaveProgress>(_onSaveProgress);
  }

  Future<void> _onLoadPracticeData(
    LoadPracticeData event,
    Emitter<PracticeState> emit,
  ) async {
    emit(PracticeLoading());
    try {
      final data = await repository.loadAthkarData();
      final category = data.categories.firstWhere(
        (c) => c.id == event.categoryId,
        orElse: () => data.categories.isNotEmpty
            ? data.categories.first
            : throw Exception('No categories found'),
      );

      final items = category.items;
      if (items.isEmpty) throw Exception('No items in category');

      // Load ALL items' progress from database (independent counters)
      _itemsProgress = await localRepository.getAllItemsProgress(
        event.categoryId,
      );

      // DEBUG: Print loaded progress
      print('🔵 [PracticeBloc] Loading category: ${event.categoryId}');
      print('🔵 [PracticeBloc] Items count: ${items.length}');
      print('🔵 [PracticeBloc] Loaded progress from DB: $_itemsProgress');

      // Start at the first incomplete item
      int initialIndex = 0;
      for (int i = 0; i < items.length; i++) {
        final itemCount = _itemsProgress[i] ?? 0;
        final targetCount = items[i].repeat;
        if (itemCount < targetCount) {
          initialIndex = i;
          break;
        }
        // If all items are complete, stay on the last one
        if (i == items.length - 1) {
          initialIndex = i;
        }
      }

      final initialCount = _itemsProgress[initialIndex] ?? 0;
      print(
        '🔵 [PracticeBloc] Starting at index $initialIndex with count $initialCount',
      );

      emit(
        PracticeLoaded(
          categoryId: event.categoryId,
          items: items,
          currentItem: items[initialIndex],
          currentCount: initialCount,
          isPlaying: false,
          activeTabIndex: initialIndex,
          itemsProgress: Map.from(_itemsProgress),
        ),
      );
    } catch (e) {
      print('🔴 [PracticeBloc] Error loading: $e');
      emit(PracticeInitial());
    }
  }

  Future<void> _onIncrementCounter(
    IncrementCounter event,
    Emitter<PracticeState> emit,
  ) async {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      final currentIndex = currentState.activeTabIndex;
      final target = currentState.targetCount;
      final newCount = currentState.currentCount + 1;

      // Update cache
      _itemsProgress[currentIndex] = newCount;

      // Save this item's progress independently
      print('🟢 [PracticeBloc] Saving item $currentIndex with count $newCount');
      await localRepository.saveItemProgress(
        categoryId: currentState.categoryId,
        itemId: currentIndex,
        currentCount: newCount,
      );
      print('🟢 [PracticeBloc] Save completed for item $currentIndex');

      // Check if this item is completed and should advance
      if (newCount >= target) {
        final nextIndex = currentIndex + 1;

        // If there's a next item, advance to it
        if (nextIndex < currentState.items.length) {
          emit(
            currentState.copyWith(
              currentCount: newCount,
              itemsProgress: Map.from(_itemsProgress),
            ),
          );

          // Small delay before advancing
          await Future.delayed(const Duration(milliseconds: 800));

          // Get the next item's saved progress
          final nextItemCount = _itemsProgress[nextIndex] ?? 0;

          emit(
            currentState.copyWith(
              activeTabIndex: nextIndex,
              currentItem: currentState.items[nextIndex],
              currentCount: nextItemCount,
              isPlaying: false,
              itemsProgress: Map.from(_itemsProgress),
            ),
          );
        } else {
          // All items completed - mark category as completed
          emit(
            currentState.copyWith(
              currentCount: newCount,
              itemsProgress: Map.from(_itemsProgress),
            ),
          );
          await localRepository.markCategoryCompleted(currentState.categoryId);

          // Show completion for a moment before navigating back
          await Future.delayed(const Duration(milliseconds: 1500));
          emit(PracticeCompleted(categoryId: currentState.categoryId));
        }
      } else {
        emit(
          currentState.copyWith(
            currentCount: newCount,
            itemsProgress: Map.from(_itemsProgress),
          ),
        );
      }
    }
  }

  void _onResetCounter(ResetCounter event, Emitter<PracticeState> emit) async {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      final currentIndex = currentState.activeTabIndex;

      // Update cache
      _itemsProgress[currentIndex] = 0;

      emit(
        currentState.copyWith(
          currentCount: 0,
          itemsProgress: Map.from(_itemsProgress),
        ),
      );

      // Save this item's reset independently
      await localRepository.saveItemProgress(
        categoryId: currentState.categoryId,
        itemId: currentIndex,
        currentCount: 0,
      );
    }
  }

  void _onToggleAudio(ToggleAudio event, Emitter<PracticeState> emit) {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      emit(currentState.copyWith(isPlaying: !currentState.isPlaying));
    }
  }

  void _onChangeTab(ChangeTab event, Emitter<PracticeState> emit) async {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;

      if (event.tabIndex >= 0 && event.tabIndex < currentState.items.length) {
        // Get this item's saved progress from cache
        final itemCount = _itemsProgress[event.tabIndex] ?? 0;

        emit(
          currentState.copyWith(
            activeTabIndex: event.tabIndex,
            currentItem: currentState.items[event.tabIndex],
            currentCount: itemCount, // Load this item's independent count
            isPlaying: false,
          ),
        );
        // No need to save - just viewing, each item keeps its own count
      }
    }
  }

  Future<void> _onSaveProgress(
    SaveProgress event,
    Emitter<PracticeState> emit,
  ) async {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;
      // Save current item's progress
      await localRepository.saveItemProgress(
        categoryId: currentState.categoryId,
        itemId: currentState.activeTabIndex,
        currentCount: currentState.currentCount,
      );
    }
  }
}
