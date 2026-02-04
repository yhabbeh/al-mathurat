import 'package:almaathorat/core/util/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/presentation/widgets/custom_text.dart';
import '../../../practice/presentation/pages/practice_page.dart';
import '../../presentation/bloc/journey_bloc.dart';

class CategoryCardWidget extends StatelessWidget {
  final String categoryId;
  final String title;
  final String subtitle;
  final String itemCount;
  final double progress;
  final Color iconColor;
  final IconData icon;

  const CategoryCardWidget({
    super.key,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.itemCount,
    required this.progress,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => PracticePage(categoryId: categoryId),
          ),
        );

        // Reload journey data when returning from practice
        if (context.mounted) {
          context.read<JourneyBloc>().add(LoadJourneyData());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  // Soft shadow matching the color
                  BoxShadow(
                    color: iconColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            CustomText(
              title,
              styleType: CustomTextStyleType.subHeader,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            const SizedBox(height: 4),
            CustomText(
              subtitle,
              styleType: CustomTextStyleType.caption,
              color: Colors.grey,
              fontSize: 14,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  itemCount,
                  styleType: CustomTextStyleType.caption,
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                CustomText(
                  '${(progress * 100).toInt()}% ${context.tr.completed}',
                  styleType: CustomTextStyleType.caption,
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
