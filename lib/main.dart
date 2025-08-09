import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Clock1000',
      home: ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer _timer;
  int _displayMinutes = 0;

  static const int maxMinutes = 1000;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();

    final startToday = DateTime(now.year, now.month, now.day, 6, 15);

    int minutesElapsed;
    if (now.isBefore(startToday)) {
      final startYesterday = startToday.subtract(const Duration(days: 1));
      minutesElapsed = now.difference(startYesterday).inMinutes;
    } else {
      minutesElapsed = now.difference(startToday).inMinutes;
    }

    if (minutesElapsed <= maxMinutes) {
      _displayMinutes = minutesElapsed < 0 ? 0 : minutesElapsed;
    } else {
      final nextStart = startToday.add(const Duration(days: 1));
      final minutesRemaining = nextStart.difference(now).inMinutes;
      _displayMinutes = minutesRemaining < 0 ? 0 : minutesRemaining;
    }

    setState(() {});
  }

  Widget _buildProgressBar() {
    double progressValue = _displayMinutes / maxMinutes;
    if (progressValue > 1) progressValue = 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
          child: CustomPaint(
            painter: _TickPainter(maxTicks: 10),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              11,
              (index) => Text(
                    '${index * 100}',
                    style: const TextStyle(fontSize: 12),
                  )),
        ),
      ],
    );
  }

  Widget _buildFormattedNumber(int number) {
    final text = number.toString().padLeft(3, '0');
    final firstTwo = text.substring(0, 2);
    final lastOne = text.substring(2);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstTwo,
            style: const TextStyle(
                fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: lastOne,
            style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clock1000')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFormattedNumber(_displayMinutes),
            const SizedBox(height: 32),
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  final int maxTicks;
  _TickPainter({required this.maxTicks});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1;

    final tickHeight = 8.0;
    final tickSpacing = size.width / maxTicks;

    for (int i = 0; i <= maxTicks; i++) {
      final x = i * tickSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, tickHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clock1000')),
      body: Center(
        child: Text(
          '$_displayMinutes',
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
