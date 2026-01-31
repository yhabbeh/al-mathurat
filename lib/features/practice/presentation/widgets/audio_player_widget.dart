import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class AudioPlayerWidget extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onToggle;

  const AudioPlayerWidget({
    super.key,
    required this.isPlaying,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Frosted glass effect
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.pinkAccent, // As per design
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.volume_up,
                      size: 16,
                      color: AppColors.primaryText,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Audio Recitation',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Mock waveform
                SizedBox(
                  height: 24,
                  child: Row(
                    children: List.generate(30, (index) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          height: 10.0 + (index % 5) * 3, // Randomize height
                          color: isPlaying
                              ? Colors.pinkAccent.withOpacity(0.6)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
