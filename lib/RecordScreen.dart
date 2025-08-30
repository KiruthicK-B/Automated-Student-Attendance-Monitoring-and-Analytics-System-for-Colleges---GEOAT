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
    bool isSpinning = false;
  bool _isLoading = false;

  DateTime calendarMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAllRecords();
  }

  Future<void> _fetchAllRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(widget.userName.replaceAll(' ', ''))
          .get();

      allRecords = snapshot.docs
          .map((doc) => doc.data())
          .where((record) => record['email'] == widget.userEmail)
          .toList();

      _applyFilter();
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _applyFilter() {
    List<Map<String, dynamic>> tempRecords = allRecords;

    if (_selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      tempRecords =
          tempRecords.where((record) => record['date'] == formattedDate).toList();
    }

    if (_startTime != null && _endTime != null) {
      tempRecords = tempRecords.where((record) {
        final checkIn = record['fromTime'] ?? '';
        try {
          final timeParts = checkIn.split(':');
          final checkInTime =
              TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
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

  Map<String, List<String>> getCalendarMap() {
    Map<String, List<String>> map = {};
    for (var record in allRecords) {
      String date = record['date'];
      String fromTime = record['fromTime'] ?? '00:00';
      int hour = int.tryParse(fromTime.split(':')[0]) ?? 0;
      String session = hour < 12 ? 'FN' : 'AN';

      if (!map.containsKey(date)) {
        map[date] = [];
      }
      if (!map[date]!.contains(session)) {
        map[date]!.add(session);
      }
    }
    return map;
  }

  void _showRecordDetail(String date) {
    List<Map<String, dynamic>> records =
        allRecords.where((r) => r['date'] == date).toList();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Attendance on $date"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: records
              .map((r) =>
                  Text("From: ${r['fromTime'] ?? '-'} To: ${r['toTime'] ?? '-'}"))
              .toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  void _selectMonth(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = DateTime(DateTime.now().year, index + 1, 1);
              return ListTile(
                title: Text(DateFormat('MMMM').format(month)),
                onTap: () {
                  setState(() => calendarMonth = month);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

Widget buildCalendar() {
    Map<String, List<String>> calendarMap = getCalendarMap();
    int year = calendarMonth.year;
    int month = calendarMonth.month;
    int daysInMonth = DateTime(year, month + 1, 0).day;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() {
                calendarMonth = DateTime(calendarMonth.year, calendarMonth.month - 1);
              }),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(DateFormat('MMMM yyyy').format(calendarMonth),
                style: const TextStyle(fontSize: 18)),
            IconButton(
              onPressed: () => setState(() {
                calendarMonth = DateTime(calendarMonth.year, calendarMonth.month + 1);
              }),
              icon: const Icon(Icons.chevron_right),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.green),
              onPressed: () => _selectMonth(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemBuilder: (context, index) {
            final day = index + 1;
            final dateStr =
                DateFormat('yyyy-MM-dd').format(DateTime(year, month, day));
            final sessions = calendarMap[dateStr] ?? [];

            Color bgColor = Colors.transparent;
            Widget label = Text('$day');

            if (sessions.contains('FN') && sessions.contains('AN')) {
              bgColor = Colors.green;
              label = const Icon(Icons.check, color: Colors.white, size: 16);
            } else if (sessions.contains('FN') || sessions.contains('AN')) {
              bgColor = Colors.yellow.shade700;
            }

            return GestureDetector(
              onTap: () =>
                  sessions.isNotEmpty ? _showRecordDetail(dateStr) : null,
              child: Tooltip(
                message: sessions.join(', '),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  alignment: Alignment.center,
                  child: label,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
Widget buildFilters() {


  return Padding(
    padding: const EdgeInsets.all(8),
    child: Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.date_range),
          label: const Text("Date"),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2023),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
              _applyFilter();
            }
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.access_time),
          label: const Text("Start"),
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() => _startTime = picked);
              _applyFilter();
            }
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.access_time_filled),
          label: const Text("End"),
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() => _endTime = picked);
              _applyFilter();
            }
          },
        ),
        AnimatedRotation(
          turns: isSpinning ? 1 : 0,
          duration: const Duration(seconds: 1),
          child: IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            tooltip: "Clear Filters",
            onPressed: () {
              setState(() {
                isSpinning = true;
                _selectedDate = null;
                _startTime = null;
                _endTime = null;
              });
              _applyFilter();
              Future.delayed(const Duration(seconds: 1), () {
                setState(() => isSpinning = false);
              });
            },
          ),
        ),
      ],
    ),
  );
}


  Widget buildRecordList() {
    final keys = groupedRecords.keys.toList();

    return ListView.builder(
      itemCount: keys.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final key = keys[index];
        final records = groupedRecords[key]!;

        return Card(
          margin: const EdgeInsets.all(8),
          child: ExpansionTile(
            initiallyExpanded: expandedCards[index] ?? false,
            onExpansionChanged: (expanded) {
              setState(() => expandedCards[index] = expanded);
            },
            title: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: records.map((record) {
              return ListTile(
                title: Text("From: ${record['fromTime']} - To: ${record['toTime']}"),
                subtitle: Text("Location: ${record['location'] ?? 'Unknown'}"),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        return false;
      },
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  buildFilters(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildRecordList(),
                          buildCalendar(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int totalMinutes = 0;
            for (var record in allRecords) {
              String activeTime = record['activeTime'] ?? '00hrs:00mins:00s';
              List<String> timeParts =
                  activeTime.replaceAll(RegExp(r'[a-zA-Z]'), '').split(':');
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
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                ],
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.info_outline),
        ),
      ),
    );
  }
}
