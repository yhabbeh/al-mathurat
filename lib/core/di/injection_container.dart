import 'package:get_it/get_it.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/journey/presentation/bloc/journey_bloc.dart';
import '../../features/practice/presentation/bloc/practice_bloc.dart';
import '../../core/localization/bloc/language_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  // Register Factory so each time we get a new instance if needed,
  // or Singleton if we want to share state globally.
  // Usually Pages get their own BLoC instances or scoped ones.
  // For simplicity here, Factory is safer for now.

  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => JourneyBloc());
  sl.registerFactory(() => PracticeBloc());
  sl.registerFactory(() => LanguageBloc());
}
