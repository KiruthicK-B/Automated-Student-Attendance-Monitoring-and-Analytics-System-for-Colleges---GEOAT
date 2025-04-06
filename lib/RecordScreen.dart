import 'package:flutter/material.dart';
import 'index.dart';
// Define the RecordScreen as a widget
class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<Map<String, dynamic>> allRecords = [
    {
      "date": "27 Sep",
      "hours": "7hrs:44m",
      "checkIn": "09:00 AM",
      "checkOut": "05:00 PM",
      "breakTime": "1hr",
      "nonWorkingHours": "15m"
    },
    {
      "date": "28 Sep",
      "hours": "7hrs:50m",
      "checkIn": "09:05 AM",
      "checkOut": "05:10 PM",
      "breakTime": "1hr",
      "nonWorkingHours": "10m"
    },
    {
      "date": "29 Sep",
      "hours": "7hrs:30m",
      "checkIn": "08:50 AM",
      "checkOut": "04:50 PM",
      "breakTime": "1hr",
      "nonWorkingHours": "20m"
    },
    {
      "date": "30 Sep",
      "hours": "7hrs:44m",
      "checkIn": "09:15 AM",
      "checkOut": "05:00 PM",
      "breakTime": "45m",
      "nonWorkingHours": "20m"
    },
    {
      "date": "01 Oct",
      "hours": "7hrs:55m",
      "checkIn": "09:00 AM",
      "checkOut": "05:10 PM",
      "breakTime": "1hr",
      "nonWorkingHours": "5m"
    },
    {
      "date": "02 Oct",
      "hours": "7hrs:40m",
      "checkIn": "09:10 AM",
      "checkOut": "05:00 PM",
      "breakTime": "1hr",
      "nonWorkingHours": "20m"
    },
    {
      "date": "03 Oct",
      "hours": "6hrs:50m",
      "checkIn": "10:00 AM",
      "checkOut": "05:00 PM",
      "breakTime": "1hr",
      "nonWorkingHours": "10m"
    },
    {
      "date": "04 Oct",
      "hours": "7hrs:30m",
      "checkIn": "09:00 AM",
      "checkOut": "04:30 PM",
      "breakTime": "1hr",
      "nonWorkingHours": "20m"
    },
    {
      "date": "05 Oct",
      "hours": "8hrs:15m",
      "checkIn": "08:30 AM",
      "checkOut": "05:00 PM",
      "breakTime": "45m",
      "nonWorkingHours": "15m"
    },
  ];

  List<Map<String, dynamic>> filteredRecords = [];
  Map<int, bool> expandedCards = {};
  DateTime? _selectedDate;
  bool _isFetched = false;

  @override
  void initState() {
    super.initState();
    filteredRecords = allRecords; // Initially display all records
    for (int i = 0; i < filteredRecords.length; i++) {
      expandedCards[i] = false; // Initialize all cards as collapsed
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _isFetched = false; // Reset fetch status after date selection
      });
    }
  }

  void _fetchRecords() {
  if (_selectedDate != null) {
    // Format the selected date only if it's not null
    String formattedDate = DateFormat('dd MMM').format(_selectedDate!);

    setState(() {
      filteredRecords = allRecords
          .where((record) => record['date'] == formattedDate)
          .toList();
      _isFetched = true;

      // Reset expanded states
      expandedCards.clear();
      for (int i = 0; i < filteredRecords.length; i++) {
        expandedCards[i] = false;
      }
    });
  } else {
    // Handle the case where no date is selected
    setState(() {
      filteredRecords = [];
      _isFetched = true;
    });
    // Optionally, show a message to the user asking to select a date
  }
}


  String get selectedDateString {
    if (_selectedDate != null) {
      return DateFormat('dd MMM yyyy').format(_selectedDate!);
    } else {
      return '';
    }
  }

  void _toggleCardExpansion(int index) {
    setState(() {
      expandedCards[index] = !(expandedCards[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('User Record'),
      //   backgroundColor: Colors.green,
      //   automaticallyImplyLeading: false,
      // ),
      body: Column(
        children: [
          // Date Selection and Fetch Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.green),
                  onPressed: () => _selectDate(context),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? 'Selected Date: $selectedDateString'
                        : 'Select a date to fetch records',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _fetchRecords,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                  ),
                  child: const Text('Fetch',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Display fetched date
          if (_isFetched && _selectedDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Showing records for: $selectedDateString',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          // No records found message
          if (_isFetched && filteredRecords.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No records found for the selected date.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          else
            // Records List
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = filteredRecords[index];
                  final isExpanded = expandedCards[index] ?? false;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () => _toggleCardExpansion(index),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    record['date'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Basic Info
                              Text(
                                "Working Hours: ${record['hours']}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              // Expanded Details
                              if (isExpanded) ...[
                                const SizedBox(height: 10),
                                Divider(color: Colors.grey[300]),
                                const SizedBox(height: 10),
                                Text(
                                  "Check-In Time: ${record['checkIn']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Check-Out Time: ${record['checkOut']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Break Time: ${record['breakTime']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Non-Working Hours: ${record['nonWorkingHours']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
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
floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.end, // Align to the bottom of the screen
  children: [
    // Padding to move the FAB above the chatbot button
    Padding(
      padding: const EdgeInsets.only(bottom: 70.0), // Adjust this value to change FAB height
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              int totalWorkingMinutes = 0;
              for (var record in allRecords) {
                String hours = record['hours']!;
                int workingHours = int.parse(hours.split('hrs')[0]);
                int workingMinutes = int.parse(hours.split('hrs:')[1].split('m')[0]);
                totalWorkingMinutes += workingHours * 60 + workingMinutes;
              }
              int totalHours = totalWorkingMinutes ~/ 60;
              int totalMinutes = totalWorkingMinutes % 60;

              return AlertDialog(
                title: const Text('Work Summary'),
                content: Text(
                  'Total Check-In Days: ${allRecords.length}\n'
                  'Total Working Hours: $totalHours hrs $totalMinutes m\n'
                  'Average Break Time: 1hr/day\n'
                  'Average Non-Working Hours: 15m/day',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.info_outline),
      ),
    ),
  ],
),


    );
  }
}
