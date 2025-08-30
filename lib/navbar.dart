// ignore_for_file: prefer_const_constructors
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addgroup.dart';


void main() => runApp(MyApp(userName: '', userEmail: '',));

class MyApp extends StatelessWidget {
   final String userName;
  final String userEmail;
 
  const MyApp({super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Drawer Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
  appBar: AppBar(title: Text('Navigation Drawer Demo')),
  drawer: AppNavigationDrawer(
    userName: userName,
    userEmail: userEmail,
  ),
  body: Center(child: Text('Home Page')),
),

    );
  }
}
class AppNavigationDrawer extends StatefulWidget {
  final String userName;
  final String userEmail;

  const AppNavigationDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  _AppNavigationDrawerState createState() => _AppNavigationDrawerState();
}


class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  bool _isLoading = false;

  Future<void> _navigateToScreen(String route) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate loading

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop(); // Close drawer
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      switch (route) {
        case 'Dashboard':
          return DashboardScreen();
        case 'Groups':
          
        case 'Add Group':
          return AddGroupFormScreen();
        case 'Set Coordinates':
          return SetCoordinatesScreen();
        case 'Search':
          //return SearchScreen();
        case 'Active Users':
          return ActiveUsersScreen();
        case 'Statistics':
          return StatisticsScreen();
        default:
          return DashboardScreen();
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset('assets/Splash3.png'),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => _navigateToScreen('Dashboard'),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Groups'),
            onTap: () => _navigateToScreen('Groups'),
          ),
         ListTile(
  leading: Icon(Icons.add),
  title: Text('Add Users'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddGroupFormScreen(
          
        ),
      ),
    );
  },
),


          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Set Coordinates'),
            onTap: () => _navigateToScreen('Set Coordinates'),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () => _navigateToScreen('Search'),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Active Users'),
            onTap: () => _navigateToScreen('Active Users'),
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Statistics'),
            onTap: () => _navigateToScreen('Statistics'),
          ),
          Spacer(),
          ListTile(
            leading: _isLoading
                ? CircularProgressIndicator(color: Colors.green)
                : Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message
              Text(
                'Welcome, Admin!',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Stats Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Total Groups', '15', Colors.blue),
                  _buildStatCard('Active Users', '123', Colors.green),
                  _buildStatCard('Coordinates Set', '3', Colors.orange),
                ],
              ),
              const SizedBox(height: 20),

              // Recent Activity Section
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildRecentActivityList(),

              const SizedBox(height: 20),

              // Dashboard Actions Section
              Text(
                'Dashboard Actions',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.location_on,
                    label: 'Set Coordinates',
                    color: Colors.orange,
                    onTap: () {
                      // Handle set coordinates action
                    },
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.person,
                    label: 'Active Users',
                    color: Colors.green,
                    onTap: () {
                      // Handle active users action
                    },
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.bar_chart,
                    label: 'Statistics',
                    color: Colors.blue,
                    onTap: () {
                      // Handle statistics action
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Analytics Graph (Mockup for demonstration)
              Text(
                'Analytics Overview',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Graph/Chart Placeholder',
                    style: TextStyle(color: Colors.blue[300], fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build a single stat card
  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the recent activity list
  Widget _buildRecentActivityList() {
    final List<Map<String, String>> recentActivities = [
      {'title': 'User checked in', 'subtitle': 'At 10:00 AM'},
      {'title': 'New group created', 'subtitle': 'Project Team'},
      {'title': 'Coordinates updated', 'subtitle': 'Admin Office'},
    ];

    return Column(
      children: recentActivities.map((activity) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.access_time, color: Colors.blue),
            title: Text(activity['title']!),
            subtitle: Text(activity['subtitle']!),
          ),
        );
      }).toList(),
    );
  }

  // Widget to build a single action button
  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SetCoordinatesScreen extends StatefulWidget {
  const SetCoordinatesScreen({super.key});

  @override
  State<SetCoordinatesScreen> createState() => _SetCoordinatesScreenState();
}

class _SetCoordinatesScreenState extends State<SetCoordinatesScreen> {
  String? _selectedUserId;
  String? _selectedUserEmail;
  String? _selectedUserName;

  bool _isLoading = false;

  List<Map<String, dynamic>> _userList = [];

  final TextEditingController _topLeftLatController = TextEditingController();
  final TextEditingController _topLeftLngController = TextEditingController();
  final TextEditingController _bottomRightLatController = TextEditingController();
  final TextEditingController _bottomRightLngController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      setState(() => _isLoading = true);
      final snapshot = await FirebaseFirestore.instance.collection('userdetails').get();

      List<Map<String, dynamic>> fetchedUsers = [];

      for (var doc in snapshot.docs) {
        final userDetails = await FirebaseFirestore.instance
            .collection('userdetails')
            .doc(doc.id)
            .get();

        final data = userDetails.data();
        if (data != null) {
          fetchedUsers.add({
            'id': doc.id,
            'email': data['email'] ?? 'No Email',
            'name': data['name'] ?? 'No Name',
          });
        }
      }

      setState(() {
        _userList = fetchedUsers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage("❌ Error fetching users: $e");
    }
  }

  Future<void> _fetchUserCoordinates(String userId) async {
    try {
      setState(() => _isLoading = true);
      final doc = await FirebaseFirestore.instance.collection('userdetails').doc(userId).get();
      final data = doc.data();
      if (data != null) {
        _topLeftLatController.text = (data['topLeftLat'] ?? '').toString();
        _topLeftLngController.text = (data['topLeftLng'] ?? '').toString();
        _bottomRightLatController.text = (data['bottomRightLat'] ?? '').toString();
        _bottomRightLngController.text = (data['bottomRightLng'] ?? '').toString();

        setState(() {
          _selectedUserEmail = data['email'];
          _selectedUserName = data['name'];
        });
      } else {
        _clearControllers();
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage("❌ Error fetching coordinates: $e");
    }
  }

  Future<void> _saveCoordinates() async {
    if (_selectedUserId == null) return;

    final topLeftLat = double.tryParse(_topLeftLatController.text);
    final topLeftLng = double.tryParse(_topLeftLngController.text);
    final bottomRightLat = double.tryParse(_bottomRightLatController.text);
    final bottomRightLng = double.tryParse(_bottomRightLngController.text);

    if ([topLeftLat, topLeftLng, bottomRightLat, bottomRightLng].contains(null)) {
      _showMessage("⚠️ Please enter valid coordinates.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('userdetails').doc(_selectedUserId).update({
        'topLeftLat': topLeftLat,
        'topLeftLng': topLeftLng,
        'bottomRightLat': bottomRightLat,
        'bottomRightLng': bottomRightLng,
      });
      _showMessage("✅ Coordinates updated successfully.", isSuccess: true);
    } catch (e) {
      _showMessage("❌ Error saving coordinates: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearControllers() {
    _topLeftLatController.clear();
    _topLeftLngController.clear();
    _bottomRightLatController.clear();
    _bottomRightLngController.clear();
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade400,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _topLeftLatController.dispose();
    _topLeftLngController.dispose();
    _bottomRightLatController.dispose();
    _bottomRightLngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set User Coordinates'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 175, 27),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.map, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text(
                  'Assign Geofence Coordinates',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),

            const Text('Select User:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              isExpanded: true,
              hint: const Text("Choose a user"),
              value: _selectedUserId,
              items: _userList.map((user) {
                return DropdownMenuItem<String>(
                  value: user['id'],
                  child: Text("${user['name']} (${user['email']})"),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUserId = newValue;
                });
                if (newValue != null) {
                  _fetchUserCoordinates(newValue);
                }
              },
            ),

            const SizedBox(height: 20),

            if (_selectedUserEmail != null && _selectedUserName != null)
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: Text(_selectedUserName!),
                  subtitle: Text(_selectedUserEmail!),
                ),
              ),

            _buildCoordinateInput("Top Left Latitude", _topLeftLatController),
            _buildCoordinateInput("Top Left Longitude", _topLeftLngController),
            _buildCoordinateInput("Bottom Right Latitude", _bottomRightLatController),
            _buildCoordinateInput("Bottom Right Longitude", _bottomRightLngController),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveCoordinates,
                icon: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? "Fetching..." : "Save Coordinates"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.gps_fixed),
        ),
      ),
    );
  }
}class ActiveUsersScreen extends StatelessWidget {
  const ActiveUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Active Users')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'List of Active Users',
              style: TextStyle(
                fontSize: isLargeScreen ? 24 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Active Users List with status indicators
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example count
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text('User ${index + 1}', style: TextStyle(fontSize: isLargeScreen ? 18 : 14)),
                      subtitle: Text('Status: Active'),
                      trailing: Icon(Icons.more_vert),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons for Admin Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // _buildActionButton(
                //   label: 'Add User',
                //   color: Colors.blue,
                //   icon: Icons.person_add,
                //   onTap: () {
                //     // Add User functionality
                //   },
                // ),
                _buildActionButton(
                  label: 'Refresh',
                  color: Colors.orange,
                  icon: Icons.refresh,
                  onTap: () {
                    // Refresh functionality
                  },
                ),
                _buildActionButton(
                  label: 'Export List',
                  color: Colors.green,
                  icon: Icons.download,
                  onTap: () {
                    // Export functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Action Button
  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Statistics Overview',
              style: TextStyle(
                fontSize: isLargeScreen ? 24 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Statistics Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Total Users', '100', Colors.blue),
                _buildStatCard('Total Groups', '20', Colors.orange),
                _buildStatCard('Active Users Today', '50', Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // Overview Section
            Text(
              'Daily Insights',
              style: TextStyle(
                fontSize: isLargeScreen ? 20 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildInsightCard('Highest Activity Time', '11:00 AM - 1:00 PM'),
            _buildInsightCard('Most Active Group', 'Project Team Alpha'),
            _buildInsightCard('Inactive Users', '15'),

            const SizedBox(height: 20),

            // Action Buttons for Statistics Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  label: 'Refresh Stats',
                  color: Colors.blue,
                  icon: Icons.refresh,
                  onTap: () {
                    // Refresh stats functionality
                  },
                ),
                _buildActionButton(
                  label: 'Export Data',
                  color: Colors.green,
                  icon: Icons.download,
                  onTap: () {
                    // Export data functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Stat Card
  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Insight Card
  Widget _buildInsightCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget for Action Button
  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
