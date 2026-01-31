import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/presentation/widgets/custom_text.dart';
import '../../../../core/util/localization_extension.dart';

class ProgressListWidget extends StatelessWidget {
  const ProgressListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            context.tr.yourProgress,
            styleType: CustomTextStyleType.subHeader,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
          const SizedBox(height: 16),
          // Mock List
          _buildProgressItem('1', 'SubhanAllah', '2', '33'),
          _buildProgressItem('2', 'Alhamdulillah', '0', '33'),
          _buildProgressItem('3', 'Allahu Akbar', '0', '34'),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
    String number,
    String title,
    String current,
    String total,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CustomText(
            number,
            styleType: CustomTextStyleType.body,
            color: Colors.grey,
            fontSize: 16,
          ),
          const SizedBox(width: 24),
          CustomText(
            title,
            styleType: CustomTextStyleType.body,
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                '$current/$total',
                styleType: CustomTextStyleType.caption,
                color: Colors.grey,
                fontSize: 14,
              ),
              const SizedBox(height: 4),
              // Tiny progress bar
              SizedBox(
                width: 40,
                height: 4,
                child: LinearProgressIndicator(
                  value: int.parse(current) / int.parse(total),
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
