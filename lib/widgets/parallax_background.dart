import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class ParallaxBackground extends StatefulWidget {
  final Widget child;

  const ParallaxBackground({
    super.key,
    required this.child,
  });

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParallaxPainter(
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class ParallaxPainter extends CustomPainter {
  final double animationValue;

  ParallaxPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw animated circles with glow effect
    for (int i = 0; i < 5; i++) {
      final offset = animationValue * 2 * math.pi + (i * math.pi / 2.5);
      final x = size.width / 2 +
          math.cos(offset) * (size.width / 4) * (1 + i * 0.2);
      final y = size.height / 2 +
          math.sin(offset) * (size.height / 4) * (1 + i * 0.2);

      // Glow effect
      paint.color = AppTheme.lightBlue.withOpacity(0.1);
      paint.strokeWidth = 8;
      canvas.drawCircle(
        Offset(x, y),
        30 + i * 10,
        paint,
      );

      // Main circle
      paint.color = AppTheme.primaryBlue.withOpacity(0.2);
      paint.strokeWidth = 2;
      canvas.drawCircle(
        Offset(x, y),
        30 + i * 10,
        paint,
      );
    }

    // Draw animated lines
    for (int i = 0; i < 3; i++) {
      final offset = animationValue * 2 * math.pi + (i * math.pi);
      final x1 = size.width * 0.2;
      final y1 = size.height * 0.3 + math.sin(offset) * 50;
      final x2 = size.width * 0.8;
      final y2 = size.height * 0.7 + math.cos(offset) * 50;

      paint.color = AppTheme.lightBlue.withOpacity(0.15);
      paint.strokeWidth = 1;
      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParallaxPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
