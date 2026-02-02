import 'package:get_it/get_it.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/journey/presentation/bloc/journey_bloc.dart';
import '../../features/practice/presentation/bloc/practice_bloc.dart';
import '../../core/localization/bloc/language_bloc.dart';

import '../../features/home/data/repositories/prayer_time_repository.dart';
import '../../features/home/presentation/bloc/prayer_time_bloc.dart';

import '../../core/services/location_service.dart';
import '../../core/services/ip_location_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => IpLocationService());

  // Repositories
  sl.registerLazySingleton(() => PrayerTimeRepository());

  // Blocs
  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => JourneyBloc());
  sl.registerFactory(() => PracticeBloc());
  sl.registerFactory(() => LanguageBloc());
  sl.registerFactory(
    () => PrayerTimeBloc(
      repository: sl(),
      locationService: sl(),
      ipLocationService: sl(),
    ),
  );
}
