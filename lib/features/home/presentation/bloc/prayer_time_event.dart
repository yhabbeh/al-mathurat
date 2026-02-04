part of 'prayer_time_bloc.dart';

abstract class PrayerTimeEvent extends Equatable {
  const PrayerTimeEvent();

  @override
  List<Object> get props => [];
}

class LoadPrayerTimes extends PrayerTimeEvent {}

class RequestLocation extends PrayerTimeEvent {
  final bool manualSelect;
  const RequestLocation({this.manualSelect = false});

  @override
  List<Object> get props => [manualSelect];
}

class UpdatePrayerSettings extends PrayerTimeEvent {
  final int calculationMethod;
  final int juristicMethod;

  const UpdatePrayerSettings({
    required this.calculationMethod,
    required this.juristicMethod,
  });

  @override
  List<Object> get props => [calculationMethod, juristicMethod];
}

class ScheduleWeeklyNotifications extends PrayerTimeEvent {
  final Map<String, dynamic>? todayTimings;
  const ScheduleWeeklyNotifications({this.todayTimings});
}

class TestNotification extends PrayerTimeEvent {}
