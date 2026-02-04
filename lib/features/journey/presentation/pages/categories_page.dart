import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/util/localization_extension.dart';
import '../bloc/journey_bloc.dart';
import '../widgets/category_card_widget.dart';
import '../widgets/bottom_stats_widget.dart';
import '../../../practice/presentation/widgets/athkar_search_delegate.dart';
import '../../../practice/data/repositories/practice_repository.dart';

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
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: AthkarSearchDelegate(
                        repository: sl<PracticeRepository>(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<JourneyBloc, JourneyState>(
          builder: (context, state) {
            if (state is JourneyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JourneyLoaded) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.purpleIcon,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // Text(
                            //   context.tr.chooseCategory,
                            //   style: const TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 16,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                            // const SizedBox(height: 10),
                            BottomStatsWidget(
                              streakDays: state.streakDays,
                              completedSessions: state.completedSessions,
                              activityMinutes: state.activityMinutes,
                            ),
                            // const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.90,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final cat = state.categories[index];
                          return CategoryCardWidget(
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
                          );
                        }, childCount: state.categories.length),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
