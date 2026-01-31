import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/util/localization_extension.dart';
import '../bloc/journey_bloc.dart';
import '../widgets/category_card_widget.dart';
import '../widgets/focus_of_day_widget.dart';
import '../widgets/bottom_stats_widget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JourneyBloc>()..add(LoadJourneyData()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.tr.categories,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<JourneyBloc, JourneyState>(
          builder: (context, state) {
            if (state is JourneyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JourneyLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      context.tr.chooseCategory,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Map categories
                    ...state.categories.map(
                      (cat) => CategoryCardWidget(
                        title: cat.title,
                        subtitle: cat.subtitle,
                        itemCount: cat.itemCount,
                        progress: cat.progress,
                        iconColor: Color(cat.colorValue),
                        icon: IconData(
                          cat.iconCodePoint,
                          fontFamily: 'MaterialIcons',
                        ),
                      ),
                    ),
                    const FocusOfDayWidget(),
                    BottomStatsWidget(
                      streakDays: state.streakDays,
                      completedSessions: state.completedSessions,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            } else if (state is JourneyError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
