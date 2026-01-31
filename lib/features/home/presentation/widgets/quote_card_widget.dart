import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class QuoteCardWidget extends StatelessWidget {
  final String quote;
  final String surahName;

  const QuoteCardWidget({
    super.key,
    required this.quote,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.format_quote,
            color: AppColors.orangeAction,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            quote,
            style: const TextStyle(
              fontSize: 22,
              height: 1.6,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
              fontFamily: 'Amiri', // Assuming you might have Arabic font
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            surahName,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
