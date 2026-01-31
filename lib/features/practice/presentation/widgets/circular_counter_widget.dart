import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class CircularCounterWidget extends StatelessWidget {
  final int currentCount;
  final int targetCount;
  final String label;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const CircularCounterWidget({
    super.key,
    required this.currentCount,
    required this.targetCount,
    required this.label,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 480, // Taller to fit the buttons below
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Semi-transparent card
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _SegmentedCirclePainter(
              progress: targetCount > 0 ? currentCount / targetCount : 0,
              activeColor: AppColors.orangeAction,
              inactiveColor: Colors.white.withOpacity(0.3),
            ),
            child: SizedBox(
              width: 220,
              height: 220,
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    fontFamily: 'Amiri', // Or Arabic font
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '$currentCount',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.orangeAction,
            ),
          ),
          Text(
            '/ $targetCount',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onIncrement,
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.add, color: Colors.white, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  onPressed: onReset,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedCirclePainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _SegmentedCirclePainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = 12.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final segmentAngle = (2 * pi) / 4;
    final gap = 0.2;

    for (int i = 0; i < 4; i++) {
      final startAngle = -pi / 2 + i * segmentAngle + gap / 2;
      final sweepAngle = segmentAngle - gap;

      paint.color = inactiveColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }

    paint.color = activeColor;

    for (int i = 0; i < 4; i++) {
      final startAngle = -pi / 2 + i * segmentAngle + gap / 2;
      final maxSweep = segmentAngle - gap;

      double segmentStart = i * 0.25;
      double segmentEnd = (i + 1) * 0.25;

      if (progress > segmentStart) {
        double currentSegmentProgress = 0;
        if (progress >= segmentEnd) {
          currentSegmentProgress = 1.0;
        } else {
          currentSegmentProgress = (progress - segmentStart) / 0.25;
        }

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          maxSweep * currentSegmentProgress,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
