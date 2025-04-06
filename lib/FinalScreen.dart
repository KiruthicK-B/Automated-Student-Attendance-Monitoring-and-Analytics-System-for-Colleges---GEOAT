import 'dart:async';
import 'package:flutter/material.dart';

class FinalScreen extends StatefulWidget {
  const FinalScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  int seconds = 0; // Total active time in seconds
  int breakSeconds = 0; // Break time in seconds
  Timer? timer;
  bool isActive = false; // For tracking work session
  bool isBreak = false; // For tracking break session
  bool isCheckedOut = false;
  bool isBreakTimeLimitExceeded = false;

  static const int breakTimeLimit = 600; // Limit for break time in seconds

  // Start timer
  void startTimer() {
    isActive = true;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (isBreak) {
          breakSeconds++;
          if (breakSeconds >= breakTimeLimit) {
            _autoCheckout();
          }
        } else {
          seconds++;
        }
      });
    });
  }

  // Pause the timer (mark it as break)
  void pauseTimer() {
    setState(() {
      isBreak = true;
    });
  }

  // Resume the timer (exit break mode)
  void resumeTimer() {
    setState(() {
      isBreak = false;
    });
  }

  // Stop the timer on checkout
  void stopTimer() {
    timer?.cancel();
    isActive = false;
  }

  // Automatically check out after break limit exceeds
  void _autoCheckout() {
    stopTimer();
    setState(() {
      isBreakTimeLimitExceeded = true;
      isCheckedOut = true;
    });
  }

  // Checkout manually
  void checkOut() {
    stopTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Checking Out..."),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      setState(() {
        isCheckedOut = true;
      });
    });
  }

  // Format time into hours, minutes, seconds
  String formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int secs = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}hrs:${minutes.toString().padLeft(2, '0')}mins:${secs.toString().padLeft(2, '0')}s";
  }

  // Build a real-time bar chart in horizontal format
  Widget buildHorizontalBarChart() {
    final Map<String, int> data = {
      'Work': seconds,
      'Break': breakSeconds,
      'Idle': 3600 - (seconds + breakSeconds), // Example total time
    };
    final int maxTime = data.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        final double barWidth = (entry.value / maxTime) * 200; // Scale for width
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${entry.key} (${formatTime(entry.value)})",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: barWidth,
                decoration: BoxDecoration(
                  color: entry.key == 'Work'
                      ? Colors.green
                      : entry.key == 'Break'
                          ? Colors.orange
                          : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6AB547),
        title: const Text("Check In Details"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile and Location Details
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpeg'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kiruthick B',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Location: Lat: 11.7321, Long: 78.0489'),
              const Text('Region: Salem, Tamil Nadu, India'),
              const SizedBox(height: 10),

              // Active and Break Times
              Text('Active Time: ${formatTime(seconds)}'),
              const SizedBox(height: 10),
              Text('Break Time: ${formatTime(breakSeconds)}'),
              const SizedBox(height: 10),

              // Active Status Indicator
              const Text('Active Status:'),
              Icon(
                isCheckedOut ? Icons.cancel : Icons.check_circle,
                color: isCheckedOut ? Colors.red : Colors.green,
                size: 30,
              ),
              const SizedBox(height: 20),

              // Action Buttons
              if (!isCheckedOut && !isBreakTimeLimitExceeded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isBreak ? resumeTimer : pauseTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 35.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(isBreak ? 'Resume' : 'Pause',
                          style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: checkOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6AB547),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 35.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Check Out', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),

              // Auto-Checkout or Checked-Out Message
              if (isBreakTimeLimitExceeded)
                const Text(
                  "Break Time Limit Exceeded. You've been automatically checked out.",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              if (isCheckedOut)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontSize: 18)),
                ),
              const SizedBox(height: 20),

              // Inspirational Message
              const Text(
                "Great things are done by taking small steps every day. Let’s make today count!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Activity Summary Section
              const Text(
                "Activity Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Horizontal Bar Chart with Overflow Handling
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHorizontalBarChart(),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Work: ${formatTime(seconds)}'),
                        Text('Break: ${formatTime(breakSeconds)}'),
                        Text(
                          'Idle: ${formatTime(3600 - (seconds + breakSeconds))}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
