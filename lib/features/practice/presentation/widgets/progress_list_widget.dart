import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/presentation/widgets/custom_text.dart';
import '../../../../core/util/localization_extension.dart';
import '../bloc/practice_bloc.dart';

class ProgressListWidget extends StatelessWidget {
  const ProgressListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeBloc, PracticeState>(
      builder: (context, state) {
        if (state is! PracticeLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.format_list_bulleted_rounded,
                    color: AppColors.orangeAction,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    context.tr.yourProgress,
                    styleType: CustomTextStyleType.subHeader,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryText,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orangeAction.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${state.activeTabIndex + 1}/${state.items.length}',
                      style: TextStyle(
                        color: AppColors.orangeAction,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Athkar items list
              ...state.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == state.activeTabIndex;

                // Get this item's count from the itemsProgress map
                final itemCount = state.getItemCount(index);
                final isCompleted = itemCount >= item.repeat;
                final progress = itemCount / item.repeat;

                return _buildProgressItem(
                  context: context,
                  index: index + 1,
                  text: item.title ?? item.text,
                  current: itemCount, // Each item's independent count
                  total: item.repeat,
                  progress: progress.clamp(0.0, 1.0),
                  isActive: isActive,
                  isCompleted: isCompleted,
                  onTap: () {
                    context.read<PracticeBloc>().add(ChangeTab(index));
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressItem({
    required BuildContext context,
    required int index,
    required String text,
    required int current,
    required int total,
    required double progress,
    required bool isActive,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    // Truncate long text for display
    final displayText = text.length > 40 ? '${text.substring(0, 40)}...' : text;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.orangeAction.withOpacity(0.08)
              : isCompleted
              ? const Color(0xFF10B981).withOpacity(0.05)
              : Colors.grey.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? AppColors.orangeAction.withOpacity(0.3)
                : isCompleted
                ? const Color(0xFF10B981).withOpacity(0.2)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF10B981)
                    : isActive
                    ? AppColors.orangeAction
                    : Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                        '$index',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Text(
                displayText,
                textDirection: TextDirection.rtl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isCompleted
                      ? const Color(0xFF059669)
                      : isActive
                      ? AppColors.primaryText
                      : Colors.grey[600],
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$current/$total',
                  style: TextStyle(
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : isActive
                        ? AppColors.orangeAction
                        : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 48,
                  height: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted
                            ? const Color(0xFF10B981)
                            : AppColors.orangeAction,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
