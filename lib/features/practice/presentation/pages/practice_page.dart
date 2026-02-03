import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/util/localization_extension.dart';
import '../bloc/practice_bloc.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/practice_tabs_widget.dart';
import '../widgets/athkar_counter_widget.dart';
import '../widgets/progress_list_widget.dart';

class PracticePage extends StatelessWidget {
  final String categoryId;

  const PracticePage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<PracticeBloc>()..add(LoadPracticeData(categoryId: categoryId)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            context.tr.practice,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.translate, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'العربية',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE0E7FF), Color(0xFFF3E8FF), Color(0xFFFDF4FF)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: BlocBuilder<PracticeBloc, PracticeState>(
              builder: (context, state) {
                if (state is PracticeLoaded) {
                  return ListView(
                    children: [
                      AudioPlayerWidget(
                        isPlaying: state.isPlaying,
                        onToggle: () =>
                            context.read<PracticeBloc>().add(ToggleAudio()),
                      ),
                      const SizedBox(height: 16),
                      PracticeTabsWidget(
                        activeTabIndex: state.activeTabIndex,
                        onTabChanged: (index) =>
                            context.read<PracticeBloc>().add(ChangeTab(index)),
                        tabs: state.items.map((e) => e.text).toList(),
                      ),
                      const SizedBox(height: 30),
                      AthkarCounterWidget(
                        title: state.currentItem?.title,
                        athkarText: state.label,
                        virtueText:
                            state.currentItem?.virtueNotification?.enabled ==
                                true
                            ? state.currentItem?.virtueNotification?.text
                            : null,
                        currentCount: state.currentCount,
                        targetCount: state.targetCount,
                        onTap: () => context.read<PracticeBloc>().add(
                          IncrementCounter(),
                        ),
                        onReset: () =>
                            context.read<PracticeBloc>().add(ResetCounter()),
                      ),
                      // const Spacer(),
                      SizedBox(height: 16),
                      ProgressListWidget(),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
