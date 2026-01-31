part of 'practice_bloc.dart';

abstract class PracticeState extends Equatable {
  const PracticeState();

  @override
  List<Object> get props => [];
}

class PracticeInitial extends PracticeState {}

class PracticeLoading extends PracticeState {}

class PracticeLoaded extends PracticeState {
  final int currentCount;
  final int targetCount;
  final String label;
  final bool isPlaying;
  final int activeTabIndex;

  const PracticeLoaded({
    required this.currentCount,
    required this.targetCount,
    required this.label,
    required this.isPlaying,
    required this.activeTabIndex,
  });

  PracticeLoaded copyWith({
    int? currentCount,
    int? targetCount,
    String? label,
    bool? isPlaying,
    int? activeTabIndex,
  }) {
    return PracticeLoaded(
      currentCount: currentCount ?? this.currentCount,
      targetCount: targetCount ?? this.targetCount,
      label: label ?? this.label,
      isPlaying: isPlaying ?? this.isPlaying,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }

  @override
  List<Object> get props => [
    currentCount,
    targetCount,
    label,
    isPlaying,
    activeTabIndex,
  ];
}
