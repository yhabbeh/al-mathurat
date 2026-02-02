part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String greeting;
  final String quote;
  final String surahName;
  final int activityMinutes;
  final int completedActivities;
  final int streakDays;
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.greeting = '',
    this.quote = '',
    this.surahName = '',
    this.activityMinutes = 0,
    this.completedActivities = 0,
    this.streakDays = 0,
    this.errorMessage = '',
  });

  // Factory for loading state with dummy data for skeletonizer
  factory HomeState.loading() {
    return const HomeState(
      status: HomeStatus.loading,
      greeting: 'Welcome back',
      quote: 'Loading quote text for skeletonizer display...',
      surahName: 'Surah Name',
      activityMinutes: 0,
      completedActivities: 0,
      streakDays: 0,
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    String? greeting,
    String? quote,
    String? surahName,
    int? activityMinutes,
    int? completedActivities,
    int? streakDays,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      greeting: greeting ?? this.greeting,
      quote: quote ?? this.quote,
      surahName: surahName ?? this.surahName,
      activityMinutes: activityMinutes ?? this.activityMinutes,
      completedActivities: completedActivities ?? this.completedActivities,
      streakDays: streakDays ?? this.streakDays,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    greeting,
    quote,
    surahName,
    activityMinutes,
    completedActivities,
    streakDays,
    errorMessage,
  ];
}
