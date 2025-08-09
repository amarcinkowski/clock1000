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

    // Godzina startu: dziś 6:15
    final startToday = DateTime(now.year, now.month, now.day, 6, 15);

    int minutesElapsed;
    if (now.isBefore(startToday)) {
      // Jeśli jest przed 6:15, to start jest wczoraj
      final startYesterday = startToday.subtract(const Duration(days: 1));
      minutesElapsed = now.difference(startYesterday).inMinutes;
    } else {
      minutesElapsed = now.difference(startToday).inMinutes;
    }

    if (minutesElapsed <= 1000) {
      _displayMinutes = minutesElapsed < 0 ? 0 : minutesElapsed;
    } else {
      // Po 1000 minutach liczmy ile zostało do kolejnej 6:15 (jutro)
      final nextStart = startToday.add(const Duration(days: 1));
      final minutesRemaining = nextStart.difference(now).inMinutes;
      _displayMinutes = minutesRemaining < 0 ? 0 : minutesRemaining;
    }

    setState(() {});
  }

  @override
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
