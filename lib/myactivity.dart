import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoAt App',
      theme: ThemeData(
        primaryColor: Color(0xFF6AB547),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int permissionCount = 23;
  int leaveCount = 3;
  int odCount = 12;
  bool isLoading = false;
  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _showLeaveForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Book Leave'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Reason for Leave'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Start Date'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'End Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  leaveCount += 1;
                });
                Navigator.pop(context);
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    isLoading = false;
                  });
                });
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showRecent(String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$type Requests'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRecentRequest('John Doe', '10 Nov - 11 Nov, 2023', '$type Request', 'Pending', Colors.orange),
              _buildRecentRequest('Jane Smith', '5 Nov - 6 Nov, 2023', '$type Request', 'Approved', Colors.green),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _onRefresh() {
    _refreshController.forward().then((_) => _refreshController.reverse());
    setState(() {});
  }

  Widget _buildRequestCard(String title, IconData icon, int count, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 28, color: color),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            count.toString(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequest(String name, String date, String requestType, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/employee.png'),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(date, style: TextStyle(color: Colors.grey)),
              Text(requestType, style: TextStyle(color: Colors.grey)),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildAttendanceStatus(String title, String count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            count,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6AB547),
        elevation: 0,
        title: Text(
          'Good Morning, Kiruthick',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          RotationTransition(
            turns: _refreshController,
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _onRefresh,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Center(
                child: Icon(
                  Icons.location_pin,
                  size: 300,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRequestCard('Permissions', Icons.mail, permissionCount, Colors.green, () => _showRecent("Permission")),
                    _buildRequestCard('Leaves', Icons.calendar_today, leaveCount, Colors.blue, _showLeaveForm),
                    _buildRequestCard('OD', Icons.work_outline, odCount, Colors.orange, () => _showRecent("OD")),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Requests Applications',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('See All'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildRecentRequest('Tony Stark', '15 Aug - 16 Aug, 2023', 'Vacation Request', 'Pending', Colors.orange),
                      _buildRecentRequest('Natasha Romanoff', '5 Aug - 7 Aug, 2023', 'Personal Leave', 'Approved', Colors.green),
                      _buildRecentRequest('Bruce Banner', '18 Sep - 19 Sep, 2023', 'Medical Leave', 'Rejected', Colors.red),
                      _buildRecentRequest('Steve Rogers', '22 Sep - 23 Sep, 2023', 'Training Request', 'In Progress', Colors.blue),
                      _buildRecentRequest('Steve Rogers', '22 Sep - 23 Sep, 2023', 'Training Request', 'In Progress', Colors.blue),
                      _buildRecentRequest('Steve Rogers', '22 Sep - 23 Sep, 2023', 'Training Request', 'In Progress', Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showLeaveForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('Book Leave', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
