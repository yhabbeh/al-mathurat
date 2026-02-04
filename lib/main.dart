import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/localization/bloc/language_bloc.dart' as core;
import 'core/util/app_bloc_observer.dart';
import 'features/home/presentation/bloc/prayer_time_bloc.dart' as core;
import 'features/home/presentation/pages/flash_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<core.LanguageBloc>()),
        BlocProvider(
          create: (_) =>
              di.sl<core.PrayerTimeBloc>()..add(core.LoadPrayerTimes()),
        ),
      ],
      child: BlocBuilder<core.LanguageBloc, core.LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Spiritual Wellness App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            locale: state.locale,
            home: const FlashScreen(),
          );
        },
      ),
    );
  }
}
