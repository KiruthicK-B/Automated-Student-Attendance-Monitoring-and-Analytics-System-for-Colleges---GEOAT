import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class FinalScreen extends StatefulWidget {
  final String email;
  const FinalScreen({super.key, required this.email});

  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  int seconds = 0;
  int breakSeconds = 0;
  Timer? timer;
  bool isBreak = false;
  bool isCheckedOut = false;
  bool isBreakTimeLimitExceeded = false;
  static const int breakTimeLimit = 600;

  String userName = '';
  String userLocation = 'Fetching...';
  DateTime? checkInTime;
  DateTime? checkOutTime;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchUserName();
    await getCurrentLocation();
    checkInTime = DateTime.now();
    startTimer();
  }

  void startTimer() {
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

  void stopTimer() {
    timer?.cancel();
  }

  void pauseTimer() => setState(() => isBreak = true);
  void resumeTimer() => setState(() => isBreak = false);

  void _autoCheckout() {
    stopTimer();
    setState(() {
      isBreakTimeLimitExceeded = true;
      isCheckedOut = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Break time exceeded. Auto checked-out!')),
    );
  }

  Future<void> fetchUserName() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('userdetails')
          .where('email', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userName = querySnapshot.docs.first['name'] ?? '';
        });
      } else {
        setState(() {
          userName = 'Unknown User';
        });
      }
    } catch (e) {
      setState(() => userName = 'Error fetching name');
      debugPrint("Error fetching username: $e");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() => userLocation = "Location permission denied");
        return;
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = "Lat: ${position.latitude}, Long: ${position.longitude}";
      });
    } catch (e) {
      setState(() => userLocation = "Failed to get location");
      debugPrint("Error getting location: $e");
    }
  }

  String formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final secs = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}hrs:${minutes.toString().padLeft(2, '0')}mins:${secs.toString().padLeft(2, '0')}s";
  }

  Widget buildHorizontalBarChart() {
    final Map<String, int> data = {
      'Work': seconds,
      'Break': breakSeconds,
      'Idle': (3600 - (seconds + breakSeconds)).clamp(0, 3600),
    };
    final maxTime = data.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        final barWidth = (entry.value / maxTime) * 200;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Text("${entry.key} (${formatTime(entry.value)})"),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: barWidth,
                decoration: BoxDecoration(
                  color: entry.key == 'Work' ? Colors.green : entry.key == 'Break' ? Colors.orange : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> checkOut() async {
    stopTimer();
    checkOutTime = DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Saving data..."),
          ],
        ),
      ),
    );

    try {
      final data = {
        'email': widget.email,
        'name': userName,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'fromTime': DateFormat('HH:mm:ss').format(checkInTime!),
        'toTime': DateFormat('HH:mm:ss').format(checkOutTime!),
        'activeTime': formatTime(seconds),
        'breakTime': formatTime(breakSeconds),
        'location': userLocation,
      };

      final safeUserCollection = userName.replaceAll(" ", "").isEmpty ? "UnknownUser" : userName.replaceAll(" ", "");
      final userCollection = FirebaseFirestore.instance.collection(safeUserCollection);

      await userCollection.add(data);
      Navigator.pop(context); // Close saving dialog

      setState(() {
        isCheckedOut = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
  content: Text(
    "Check-out successful!",
    style: TextStyle(color: Colors.white), // text color
  ),
  backgroundColor: Colors.green, // green background
)

      );
    } catch (e) {
      Navigator.pop(context); // Close saving dialog even on failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to check out: $e")),
      );
      debugPrint("Check-out error: $e");
    }
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
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpeg'),
              ),
              const SizedBox(height: 20),
              Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Location: $userLocation'),
              const SizedBox(height: 10),

              Text('Active Time: ${formatTime(seconds)}'),
              const SizedBox(height: 10),
              Text('Break Time: ${formatTime(breakSeconds)}'),
              const SizedBox(height: 10),

              const Text('Active Status:'),
              Icon(
                isCheckedOut ? Icons.cancel : Icons.check_circle,
                color: isCheckedOut ? Colors.red : Colors.green,
                size: 30,
              ),
              const SizedBox(height: 20),

              if (!isCheckedOut && !isBreakTimeLimitExceeded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isBreak ? resumeTimer : pauseTimer,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: Text(isBreak ? 'Resume' : 'Pause'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: checkOut,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6AB547)),
                      child: const Text('Check Out'),
                    ),
                  ],
                ),

              if (isCheckedOut)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Back to Home'),
                ),

              const SizedBox(height: 30),
              const Text("Activity Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildHorizontalBarChart(),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Work: ${formatTime(seconds)}'),
                        Text('Break: ${formatTime(breakSeconds)}'),
                        Text('Idle: ${formatTime((3600 - (seconds + breakSeconds)).clamp(0, 3600))}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
