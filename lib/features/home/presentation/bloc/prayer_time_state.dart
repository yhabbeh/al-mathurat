part of 'prayer_time_bloc.dart';

abstract class PrayerTimeState extends Equatable {
  const PrayerTimeState();

  @override
  List<Object> get props => [];
}

class PrayerTimeInitial extends PrayerTimeState {}

class PrayerTimeLoading extends PrayerTimeState {}

class PrayerTimeLoaded extends PrayerTimeState {
  final String nextPrayerName;
  final String nextPrayerTime;
  final Duration timeRemaining;

  const PrayerTimeLoaded({
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.timeRemaining,
  });

  @override
  List<Object> get props => [nextPrayerName, nextPrayerTime, timeRemaining];
}

class PrayerTimeLocationPermissionRequired extends PrayerTimeState {}

class PrayerTimeError extends PrayerTimeState {
  final String message;

  const PrayerTimeError(this.message);

  @override
  List<Object> get props => [message];
}
