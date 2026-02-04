import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/util/localization_extension.dart';
import '../bloc/journey_bloc.dart';
import '../widgets/category_card_widget.dart';
import '../widgets/bottom_stats_widget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late JourneyBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<JourneyBloc>()..add(LoadJourneyData());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _bloc.add(LoadJourneyData());
    // Wait for the state to change to loaded
    await _bloc.stream.firstWhere(
      (state) => state is JourneyLoaded || state is JourneyError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
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
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.purpleIcon,
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    Text(
                      context.tr.chooseCategory,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    BottomStatsWidget(
                      streakDays: state.streakDays,
                      completedSessions: state.completedSessions,
                      activityMinutes: state.activityMinutes,
                    ),
                    const SizedBox(height: 32),
                    // Map categories
                    ...state.categories.map(
                      (cat) => CategoryCardWidget(
                        categoryId: cat.id,
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
                    const SizedBox(height: 24),
                  ],
                ),
              );
            } else if (state is JourneyError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _bloc.add(LoadJourneyData()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
