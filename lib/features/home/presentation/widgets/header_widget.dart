import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';

class HeaderWidget extends StatelessWidget {
  final String greeting;

  const HeaderWidget({super.key, required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'English',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 4),
                Icon(Icons.translate, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Container(
        //   width: 80,
        //   height: 80,
        //   decoration: BoxDecoration(
        //     color: Colors.white.withOpacity(0.5),
        //     shape: BoxShape.circle,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.05),
        //         blurRadius: 10,
        //         offset: const Offset(0, 4),
        //       ),
        //     ],
        //   ),
        //   child:
        //    const Icon(
        //     Icons.wb_sunny_outlined,
        //     size: 40,
        //     color: Colors.amber,
        //   ),
        // ),
        const SizedBox(height: 24),
        Text(
          greeting,
          style: AppTextStyles.arabicTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'مرحباً بك في المأثورات',
          style: AppTextStyles.arabicSubtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
