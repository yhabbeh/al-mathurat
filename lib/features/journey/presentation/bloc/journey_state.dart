part of 'journey_bloc.dart';

class CategoryModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String itemCount;
  final double progress;
  final int
  colorValue; // Storing int to avoid importing Flutter Material in pure dart if possible, but State usually needs UI data
  final int iconCodePoint;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.itemCount,
    required this.progress,
    required this.colorValue,
    required this.iconCodePoint,
  });

  @override
  List<Object> get props => [
    id,
    title,
    subtitle,
    itemCount,
    progress,
    colorValue,
    iconCodePoint,
  ];
}

abstract class JourneyState extends Equatable {
  const JourneyState();

  @override
  List<Object> get props => [];
}

class JourneyInitial extends JourneyState {}

class JourneyLoading extends JourneyState {}

class JourneyLoaded extends JourneyState {
  final List<CategoryModel> categories;
  final int streakDays;
  final int completedSessions;
  final int activityMinutes;

  const JourneyLoaded({
    required this.categories,
    required this.streakDays,
    required this.completedSessions,
    this.activityMinutes = 0,
  });

  @override
  List<Object> get props => [
    categories,
    streakDays,
    completedSessions,
    activityMinutes,
  ];
}

class JourneyError extends JourneyState {
  final String message;

  const JourneyError(this.message);

  @override
  List<Object> get props => [message];
}
