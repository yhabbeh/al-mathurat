import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class PracticeTabsWidget extends StatelessWidget {
  final int activeTabIndex;
  final ValueChanged<int> onTabChanged;

  const PracticeTabsWidget({
    super.key,
    required this.activeTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildTab('سُبْحَانَ اللَّهِ', 0),
          const SizedBox(width: 12),
          _buildTab('الْحَمْدُ لِلَّهِ', 1),
          const SizedBox(width: 12),
          _buildTab('اللَّهُ أَكْبَرُ', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = activeTabIndex == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.orangeAction
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
