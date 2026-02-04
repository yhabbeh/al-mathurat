import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/practice_bloc.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/athkar_counter_widget.dart';
import '../widgets/progress_list_widget.dart';

class PracticePage extends StatefulWidget {
  final String categoryId;
  final String title;
  final int? initialItemId;

  const PracticePage({
    super.key,
    required this.categoryId,
    required this.title,
    this.initialItemId,
  });

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage>
    with WidgetsBindingObserver {
  late PracticeBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = sl<PracticeBloc>()
      ..add(
        LoadPracticeData(
          categoryId: widget.categoryId,
          initialItemId: widget.initialItemId,
        ),
      );
  }

  @override
  void dispose() {
    // Save progress when leaving the page
    _bloc.add(SaveProgress());
    WidgetsBinding.instance.removeObserver(this);
    _bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Save progress when app goes to background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _bloc.add(SaveProgress());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<PracticeBloc, PracticeState>(
        listener: (context, state) {
          if (state is PracticeCompleted) {
            // Navigate back when practice is completed
            Navigator.pop(context, true); // Pass true to indicate completion
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color.fromARGB(255, 255, 244, 232),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
              onPressed: () {
                // Save progress before navigating back
                _bloc.add(SaveProgress());
                Navigator.pop(context);
              },
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                // color: AppColors.primaryText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(right: 16.0),
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 12,
            //         vertical: 6,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.white.withOpacity(0.4),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: Row(
            //         children: const [
            //           Icon(Icons.translate, size: 16),
            //           SizedBox(width: 4),
            //           Text(
            //             'العربية',
            //             style: TextStyle(fontWeight: FontWeight.w600),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ],
          ),
          body: SafeArea(
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
                      // const SizedBox(height: 16),
                      // PracticeTabsWidget(
                      //   activeTabIndex: state.activeTabIndex,
                      //   onTabChanged: (index) => context
                      //       .read<PracticeBloc>()
                      //       .add(ChangeTab(index)),
                      //   tabs: state.items.map((e) => e.text).toList(),
                      // ),
                      // const SizedBox(height: 30),
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
                      const SizedBox(height: 16),
                      const ProgressListWidget(),
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
