part of 'practice_bloc.dart';

abstract class PracticeState extends Equatable {
  const PracticeState();

  @override
  List<Object?> get props => [];
}

class PracticeInitial extends PracticeState {}

class PracticeLoading extends PracticeState {}

class PracticeLoaded extends PracticeState {
  final List<AthkarItem> items;
  final AthkarItem? currentItem;
  final int currentCount;
  final bool isPlaying;
  final int activeTabIndex;

  const PracticeLoaded({
    this.items = const [],
    this.currentItem,
    required this.currentCount,
    required this.isPlaying,
    required this.activeTabIndex,
  });

  // Getters for UI compatibility
  String get label => currentItem?.text ?? '';
  int get targetCount => currentItem?.repeat ?? 33;

  PracticeLoaded copyWith({
    List<AthkarItem>? items,
    AthkarItem? currentItem,
    int? currentCount,
    bool? isPlaying,
    int? activeTabIndex,
  }) {
    return PracticeLoaded(
      items: items ?? this.items,
      currentItem: currentItem ?? this.currentItem,
      currentCount: currentCount ?? this.currentCount,
      isPlaying: isPlaying ?? this.isPlaying,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }

  @override
  List<Object?> get props => [
    items,
    currentItem,
    currentCount,
    isPlaying,
    activeTabIndex,
  ];
}
