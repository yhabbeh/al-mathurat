import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class PracticeTabsWidget extends StatelessWidget {
  final int activeTabIndex;
  final ValueChanged<int> onTabChanged;
  final List<String> tabs;

  const PracticeTabsWidget({
    super.key,
    required this.activeTabIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final text = entry.value;
          return Padding(
            padding: EdgeInsets.only(right: index < tabs.length - 1 ? 12.0 : 0),
            child: _buildTab(text, index),
          );
        }).toList(),
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
