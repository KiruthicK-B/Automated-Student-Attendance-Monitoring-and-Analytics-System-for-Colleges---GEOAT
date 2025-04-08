import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoat_back/index.dart' as geoat;

import 'package:intl/intl.dart';

class RecordScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const RecordScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<Map<String, dynamic>> allRecords = [];
  Map<String, List<Map<String, dynamic>>> groupedRecords = {};
  Map<int, bool> expandedCards = {};
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isFetched = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllRecords();
  }

  Future<void> _fetchAllRecords() async {
    setState(() {
      _isLoading = true;
      _isFetched = false;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(widget.userName.replaceAll(' ', ''))
          .get();

      allRecords = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((record) => record['email'] == widget.userEmail)
          .toList();

      _applyFilter();
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
      _isFetched = true;
    });
  }

  void _applyFilter() {
    List<Map<String, dynamic>> tempRecords = allRecords;

    if (_selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      tempRecords = tempRecords.where((record) => record['date'] == formattedDate).toList();
    }

    if (_startTime != null && _endTime != null) {
      tempRecords = tempRecords.where((record) {
        final checkIn = record['fromTime'] ?? '';
        try {
          final timeParts = checkIn.split(':');
          final checkInTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
          return _isTimeInRange(checkInTime, _startTime!, _endTime!);
        } catch (e) {
          return false;
        }
      }).toList();
    }

    groupedRecords = {};
    for (var record in tempRecords) {
      final date = record['date'] ?? 'Unknown';
      final fromTime = record['fromTime'] ?? '00:00';
      final hour = int.tryParse(fromTime.split(':')[0]) ?? 0;
      final session = hour < 12 ? 'FN' : 'AN';
      final key = '$date - $session';

      if (!groupedRecords.containsKey(key)) {
        groupedRecords[key] = [];
      }
      groupedRecords[key]!.add(record);
    }

    expandedCards = {
      for (int i = 0; i < groupedRecords.length; i++) i: false,
    };
  }

  bool _isTimeInRange(TimeOfDay check, TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();
    final checkDt = DateTime(now.year, now.month, now.day, check.hour, check.minute);
    final startDt = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endDt = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    return checkDt.isAfter(startDt) && checkDt.isBefore(endDt);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _applyFilter();
    }
  }

  void _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? TimeOfDay.now()),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        _applyFilter();
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dt);
  }

  void _toggleCardExpansion(int index) {
    setState(() {
      expandedCards[index] = !(expandedCards[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedKeys = groupedRecords.keys.toList();

    return WillPopScope(
  onWillPop: () async {
   Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => geoat.HomeScreen(
      userEmail: widget.userEmail,
      userName: widget.userName,
    ),
  ),
);
 // <-- set your home route here
    return false; // prevent default pop
  },
    
    child: Scaffold(
      body: Column(
        children: [
          // Filter UI
          Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
      Row(children: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.green),
          onPressed: () => _selectDate(context),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _selectedDate != null
                ? 'Selected: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}'
                : 'Pick a date',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ]),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () => _selectTime(context, true),
              child: Text('Start Time: ${_formatTimeOfDay(_startTime)}'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _selectTime(context, false),
              child: Text('End Time: ${_formatTimeOfDay(_endTime)}'),
            ),
            const SizedBox(width: 8),
           ElevatedButton(
  onPressed: _isLoading ? null : _fetchAllRecords,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(12),
  ),
  child: _isLoading
      ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : const Icon(Icons.refresh, color: Colors.white),
),

          ],
        ),
      ),
    ],
  ),
),


          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_isFetched && groupedRecords.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No records found.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: groupedKeys.length,
                itemBuilder: (context, index) {
                  final isExpanded = expandedCards[index] ?? false;
                  final sessionKey = groupedKeys[index];
                  final records = groupedRecords[sessionKey]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => _toggleCardExpansion(index),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    sessionKey,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              if (isExpanded) ...records.map((record) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        Text("Check-In: ${record['fromTime'] ?? '-'}"),
                                        Text("Check-Out: ${record['toTime'] ?? '-'}"),
                                        Text("Break Time: ${record['breakTime'] ?? '-'}"),
                                        Text("Working Hours: ${record['activeTime'] ?? '-'}"),
                                        Text("Location: ${record['location'] ?? 'N/A'}"),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(
          onPressed: () {
            int totalMinutes = 0;
            for (var record in allRecords) {
              String activeTime = record['activeTime'] ?? '00hrs:00mins:00s';
              List<String> timeParts = activeTime
                  .replaceAll('hrs', '')
                  .replaceAll('mins', '')
                  .replaceAll('s', '')
                  .split(':');
              int hrs = int.tryParse(timeParts[0]) ?? 0;
              int mins = int.tryParse(timeParts[1]) ?? 0;
              totalMinutes += hrs * 60 + mins;
            }

            int totalHours = totalMinutes ~/ 60;
            int remainingMinutes = totalMinutes % 60;

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Work Summary'),
                content: Text(
                  'Total Check-In Days: ${allRecords.length}\n'
                  'Total Active Hours: $totalHours hrs $remainingMinutes mins',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.info_outline),
        ),
      ),
    ),
    );
  }
}
