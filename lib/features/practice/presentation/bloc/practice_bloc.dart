import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/practice_repository.dart';
import '../../data/repositories/practice_local_repository.dart';
import '../../data/models/athkar_model.dart';

import 'package:audioplayers/audioplayers.dart';

part 'practice_event.dart';
part 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final PracticeRepository repository;
  final PracticeLocalRepository localRepository;
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
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

      // Start at specific item if requested, otherwise find first incomplete
      int initialIndex = 0;

      if (event.initialItemId != null) {
        final targetIndex = items.indexWhere(
          (item) => item.id == event.initialItemId,
        );
        if (targetIndex != -1) {
          initialIndex = targetIndex;
        }
      } else {
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
      final bool wasPlaying = currentState.isPlaying;

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
          // Get the next item's saved progress
          final nextItemCount = _itemsProgress[nextIndex] ?? 0;

          final newState = currentState.copyWith(
            activeTabIndex: nextIndex,
            currentItem: currentState.items[nextIndex],
            currentCount: nextItemCount,
            isPlaying: false, // Initially false, will set true if auto-playing
            itemsProgress: Map.from(_itemsProgress),
          );

          emit(newState);

          // Auto-play next item ONLY if audio was already playing
          if (wasPlaying) {
            await _playCurrentItemAudio(newState, emit);
          }
        } else {
          // All items completed - mark category as completed
          emit(
            currentState.copyWith(
              currentCount: newCount,
              itemsProgress: Map.from(_itemsProgress),
            ),
          );
          await localRepository.markCategoryCompleted(currentState.categoryId);

          await _audioPlayer.stop(); // Stop audio

          // Show completion for a moment before navigating back
          await Future.delayed(const Duration(milliseconds: 1500));
          emit(PracticeCompleted(categoryId: currentState.categoryId));
        }
      } else {
        // Not yet completed, stay on current item
        final newState = currentState.copyWith(
          currentCount: newCount,
          itemsProgress: Map.from(_itemsProgress),
          isPlaying: wasPlaying, // Maintain visual state
        );
        emit(newState);

        // If it was playing (audio loop mode), replay the audio for the next rep
        if (wasPlaying) {
          await _playCurrentItemAudio(newState, emit);
        }
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

  Future<void> _playCurrentItemAudio(
    PracticeLoaded state,
    Emitter<PracticeState> emit,
  ) async {
    final currentItem = state.currentItem;
    if (currentItem == null) return;

    final audioPath = currentItem.audio;
    if (audioPath != null && audioPath.isNotEmpty) {
      final cleanPath = audioPath.startsWith('/')
          ? audioPath.substring(1)
          : audioPath;
      final fullPath = 'bundle/athkar/Adhkar-json/$cleanPath';

      try {
        await _audioPlayer.stop(); // Ensure stopped before playing new
        await _audioPlayer.play(AssetSource(fullPath));

        // Listen for completion to increment counter
        _audioPlayer.onPlayerComplete.first.then((_) {
          if (!isClosed) {
            add(IncrementCounter()); // Auto-increment when audio finishes
          }
        });

        emit(state.copyWith(isPlaying: true));
      } catch (e) {
        print('🔴 [PracticeBloc] Error playing audio: $e');
        emit(state.copyWith(isPlaying: false));
      }
    }
  }

  Future<void> _onToggleAudio(
    ToggleAudio event,
    Emitter<PracticeState> emit,
  ) async {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;

      if (currentState.isPlaying) {
        await _audioPlayer.stop();
        emit(currentState.copyWith(isPlaying: false));
      } else {
        await _playCurrentItemAudio(currentState, emit);
      }
    }
  }

  void _onChangeTab(ChangeTab event, Emitter<PracticeState> emit) async {
    if (state is PracticeLoaded) {
      final currentState = state as PracticeLoaded;

      if (event.tabIndex >= 0 && event.tabIndex < currentState.items.length) {
        await _audioPlayer.stop(); // Stop audio

        // Get this item's saved progress from cache
        final itemCount = _itemsProgress[event.tabIndex] ?? 0;
        final bool wasPlaying = currentState.isPlaying;

        final newState = currentState.copyWith(
          activeTabIndex: event.tabIndex,
          currentItem: currentState.items[event.tabIndex],
          currentCount: itemCount, // Load this item's independent count
          isPlaying: false,
        );

        emit(newState);

        // Auto-play when switching tabs ONLY if audio was already playing
        if (wasPlaying) {
          await _playCurrentItemAudio(newState, emit);
        }
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
