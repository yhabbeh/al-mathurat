import 'package:almaathorat/features/home/presentation/bloc/prayer_time_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../journey/presentation/bloc/journey_bloc.dart';
import '../bloc/home_bloc.dart';
import '../widgets/quote_card_widget.dart';
import '../widgets/start_journey_widget.dart';
import '../widgets/prayer_times_widget.dart';
import '../widgets/activity_stats_widget.dart';
import 'surah_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeBloc>()..add(LoadHomeData())),
        BlocProvider(create: (_) => sl<JourneyBloc>()..add(LoadJourneyData())),
      ],
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 244, 232),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Refresh both blocs

                  context.read<HomeBloc>().add(LoadHomeData());
                  context.read<JourneyBloc>().add(LoadJourneyData());
                  context.read<PrayerTimeBloc>().add(LoadPrayerTimes());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state.status == HomeStatus.error) {
                          return Center(child: Text(state.errorMessage));
                        }

                        return Skeletonizer(
                          enabled: state.status == HomeStatus.loading,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // const SizedBox(height: 25),
                                QuoteCardWidget(
                                  quote: state.quote,
                                  surahName: state.surahName,
                                  onTap: () {
                                    if (state.surahNumber > 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SurahPage(
                                            surahNumber: state.surahNumber,
                                            verseNumber: state.verseNumber,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                // const SizedBox(height: 35),
                                const StartJourneyWidget(),
                                // const SizedBox(height: 35),
                                const PrayerTimesWidget(),
                                // const SizedBox(height: 35),
                                ActivityStatsWidget(
                                  streakDays: state.streakDays,
                                  completedActivities:
                                      state.completedActivities,
                                  activityMinutes: state.activityMinutes,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
