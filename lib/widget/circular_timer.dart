import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircularTimer extends StatefulWidget {
  final int? durationInSeconds;
  final double size;
  final Color color;

  const CircularTimer({
    super.key,
    this.durationInSeconds,
    this.size = 200.0,
    this.color = Colors.blue,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.durationInSeconds != null) _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _CircularTimerPainter(
            color: widget.color,
            progress: widget.durationInSeconds != null
                ? 1.0 - _elapsedSeconds / widget.durationInSeconds!
                : 1.0,
            text:
                '${(_elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
          ),
        ),
      ),
    );
  }
}

class _CircularTimerPainter extends CustomPainter {
  final Color color;
  final double progress;
  final String text;

  _CircularTimerPainter({
    required this.color,
    required this.progress,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const strokeWidth = 10.0;
    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);

    // 绘制圆形进度条背景
    canvas.drawCircle(center, radius, backgroundPaint);

    // 绘制圆形进度条
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // 居中绘制文本
    textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
