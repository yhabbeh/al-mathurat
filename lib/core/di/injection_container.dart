import 'package:get_it/get_it.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/journey/presentation/bloc/journey_bloc.dart';
import '../../features/practice/presentation/bloc/practice_bloc.dart';
import '../../core/localization/bloc/language_bloc.dart';

import '../../features/home/data/repositories/prayer_time_repository.dart';
import '../../features/home/presentation/bloc/prayer_time_bloc.dart';
import '../../features/practice/data/repositories/practice_repository.dart';
import '../../features/practice/data/repositories/practice_local_repository.dart';
import '../../features/home/data/repositories/stats_local_repository.dart';

import '../../core/services/location_service.dart';
import '../../core/services/ip_location_service.dart';
import '../../core/database/database_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // Services
  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => IpLocationService());

  // Repositories
  sl.registerLazySingleton(() => PrayerTimeRepository());
  sl.registerLazySingleton(() => PracticeRepository());
  sl.registerLazySingleton(() => PracticeLocalRepository(sl()));
  sl.registerLazySingleton(() => StatsLocalRepository(sl()));

  // Blocs
  sl.registerFactory(() => HomeBloc(statsRepository: sl()));
  sl.registerFactory(() => JourneyBloc());
  sl.registerFactory(
    () => PracticeBloc(repository: sl(), localRepository: sl()),
  );
  sl.registerFactory(() => LanguageBloc());
  sl.registerFactory(
    () => PrayerTimeBloc(
      repository: sl(),
      locationService: sl(),
      ipLocationService: sl(),
    ),
  );
}
