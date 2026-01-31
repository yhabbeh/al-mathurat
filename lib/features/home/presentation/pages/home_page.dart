import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/home_bloc.dart';
import '../widgets/header_widget.dart';
import '../widgets/quote_card_widget.dart';
import '../widgets/start_journey_widget.dart';
import '../widgets/prayer_times_widget.dart';
import '../widgets/activity_stats_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(LoadHomeData()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HomeLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HeaderWidget(greeting: state.greeting),
                          const SizedBox(height: 32),
                          QuoteCardWidget(
                            quote: state.quote,
                            surahName: state.surahName,
                          ),
                          const SizedBox(height: 32),
                          const StartJourneyWidget(),
                          const SizedBox(height: 32),
                          PrayerTimesWidget(
                            prayerName: state.prayerName,
                            prayerTime: state.prayerTime,
                          ),
                          const SizedBox(height: 24),
                          ActivityStatsWidget(
                            activityMinutes: state.activityMinutes,
                            completedActivities: state.completedActivities,
                            streakDays: state.streakDays,
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    } else if (state is HomeError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
