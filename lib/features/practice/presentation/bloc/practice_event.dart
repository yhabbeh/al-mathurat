part of 'practice_bloc.dart';

abstract class PracticeEvent extends Equatable {
  const PracticeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPracticeData extends PracticeEvent {
  final String categoryId;
  final int? initialItemId;

  const LoadPracticeData({required this.categoryId, this.initialItemId});

  @override
  List<Object?> get props => [categoryId, initialItemId];
}

class IncrementCounter extends PracticeEvent {}

class ResetCounter extends PracticeEvent {}

class ToggleAudio extends PracticeEvent {}

class ChangeTab extends PracticeEvent {
  final int tabIndex;

  const ChangeTab(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class SaveProgress extends PracticeEvent {}
