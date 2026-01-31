import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class BottomStatsWidget extends StatelessWidget {
  final int streakDays;
  final int completedSessions;

  const BottomStatsWidget({
    super.key,
    required this.streakDays,
    required this.completedSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '$streakDays',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orangeAction,
                ),
              ),
              const Text(
                'Day Streak',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2)),
          Column(
            children: [
              Text(
                '$completedSessions',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Text(
                'Sessions Completed',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
