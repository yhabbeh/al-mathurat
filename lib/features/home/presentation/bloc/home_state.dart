part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String greeting;
  final String quote;
  final String surahName;
  final String prayerName;
  final String prayerTime;
  final int activityMinutes;
  final int completedActivities;
  final int streakDays;

  const HomeLoaded({
    required this.greeting,
    required this.quote,
    required this.surahName,
    required this.prayerName,
    required this.prayerTime,
    required this.activityMinutes,
    required this.completedActivities,
    required this.streakDays,
  });

  @override
  List<Object> get props => [
    greeting,
    quote,
    surahName,
    prayerName,
    prayerTime,
    activityMinutes,
    completedActivities,
    streakDays,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
