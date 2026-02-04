part of 'practice_bloc.dart';

abstract class PracticeState extends Equatable {
  const PracticeState();

  @override
  List<Object?> get props => [];
}

class PracticeInitial extends PracticeState {}

class PracticeLoading extends PracticeState {}

class PracticeLoaded extends PracticeState {
  final String categoryId;
  final List<AthkarItem> items;
  final AthkarItem? currentItem;
  final int currentCount;
  final bool isPlaying;
  final int activeTabIndex;

  /// Map of item index -> current count (for independent item progress)
  final Map<int, int> itemsProgress;

  const PracticeLoaded({
    required this.categoryId,
    this.items = const [],
    this.currentItem,
    required this.currentCount,
    required this.isPlaying,
    required this.activeTabIndex,
    this.itemsProgress = const {},
  });

  // Getters for UI compatibility
  String get label => currentItem?.text ?? '';
  int get targetCount => currentItem?.repeat ?? 33;

  /// Get count for a specific item by index
  int getItemCount(int index) => itemsProgress[index] ?? 0;

  PracticeLoaded copyWith({
    String? categoryId,
    List<AthkarItem>? items,
    AthkarItem? currentItem,
    int? currentCount,
    bool? isPlaying,
    int? activeTabIndex,
    Map<int, int>? itemsProgress,
  }) {
    return PracticeLoaded(
      categoryId: categoryId ?? this.categoryId,
      items: items ?? this.items,
      currentItem: currentItem ?? this.currentItem,
      currentCount: currentCount ?? this.currentCount,
      isPlaying: isPlaying ?? this.isPlaying,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      itemsProgress: itemsProgress ?? this.itemsProgress,
    );
  }

  @override
  List<Object?> get props => [
    categoryId,
    items,
    currentItem,
    currentCount,
    isPlaying,
    activeTabIndex,
    itemsProgress,
  ];
}

class PracticeCompleted extends PracticeState {
  final String categoryId;

  const PracticeCompleted({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
