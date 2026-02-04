import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/presentation/widgets/custom_text.dart';
import '../../../../core/util/localization_extension.dart';
import '../../../journey/presentation/pages/categories_page.dart';

class StartJourneyWidget extends StatelessWidget {
  const StartJourneyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.orangeAction,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orangeAction.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 15),
            CustomText(
              context.tr.startJourney,
              styleType: CustomTextStyleType.body,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CustomText(
              context.tr.findPeace,
              color: const Color(0xFF6B7280),
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
            // const SizedBox(height: 32),
            // CustomButton(
            //   text: context.tr.exploreCategories,
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const CategoriesPage(),
            //       ),
            //     );
            //   },
            //   type: CustomButtonType.primary,
            // ),
          ],
        ),
      ),
    );
  }
}
