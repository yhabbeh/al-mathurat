part of 'journey_bloc.dart';

abstract class JourneyEvent extends Equatable {
  const JourneyEvent();

  @override
  List<Object> get props => [];
}

class LoadJourneyData extends JourneyEvent {}
