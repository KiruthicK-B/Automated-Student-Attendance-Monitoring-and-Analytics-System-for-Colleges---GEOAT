// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'SigninScreen.dart';
import 'addgroup.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Drawer Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(title: Text('Navigation Drawer Demo')),
        drawer: AppNavigationDrawer(),
        body: Center(child: Text('Home Page')),
      ),
    );
  }
}

class AppNavigationDrawer extends StatefulWidget {
  const AppNavigationDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
          return GroupsScreen(
            // groupName: '',
            // totalMembers: '',
            // color: Colors.green,
          );
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
            title: Text('Add Group'),
            onTap: () => _navigateToScreen('Add Group'),
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
                MaterialPageRoute(builder: (context) => SignInScreen()),
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
  // ignore: library_private_types_in_public_api
  _SetCoordinatesScreenState createState() => _SetCoordinatesScreenState();
}

class _SetCoordinatesScreenState extends State<SetCoordinatesScreen> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _organizationNameController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  String _coordinateType = 'Individual';

  // Set coordinates with validation and loading
  void _setCoordinates() async {
    setState(() {
      _isLoading = true;
    });

    final lat = double.tryParse(_latitudeController.text);
    final lng = double.tryParse(_longitudeController.text);

    if (lat == null || lng == null || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      _showMessage('Please enter valid coordinates.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 2)); // Simulate a loading operation

    setState(() {
      _latitude = lat;
      _longitude = lng;
      _isLoading = false;
    });

    _showMessage('Coordinates set successfully!');
  }

  // Display message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _organizationNameController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Coordinates')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Select type of coordinates
              const Text(
                'Coordinate Type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _coordinateType,
                items: const [
                  DropdownMenuItem(value: 'Individual', child: Text('Individual')),
                  DropdownMenuItem(value: 'Organization', child: Text('Organization')),
                  DropdownMenuItem(value: 'Group', child: Text('Group')),
                ],
                onChanged: (value) {
                  setState(() {
                    _coordinateType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Group name field if applicable
              if (_coordinateType == 'Group')
                TextField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(labelText: 'Group Name'),
                ),

              // Organization name field if applicable
              if (_coordinateType == 'Organization')
                TextField(
                  controller: _organizationNameController,
                  decoration: const InputDecoration(labelText: 'Organization Name'),
                ),

              const SizedBox(height: 20),

              // Latitude input field
              TextField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude (-90 to 90)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Longitude input field
              TextField(
                controller: _longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude (-180 to 180)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Set Coordinates button with loading spinner
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _setCoordinates,
                        child: const Text('Set Coordinates'),
                      ),
              ),
              const SizedBox(height: 30),

              // Coordinates Preview Section
              if (_latitude != null && _longitude != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Coordinates:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Latitude: $_latitude', style: const TextStyle(fontSize: 16)),
                    Text('Longitude: $_longitude', style: const TextStyle(fontSize: 16)),
                    Text('Coordinate Type: $_coordinateType', style: const TextStyle(fontSize: 16)),
                    if (_coordinateType == 'Organization')
                      Text('Organization: ${_organizationNameController.text}', style: const TextStyle(fontSize: 16)),
                    if (_coordinateType == 'Group')
                      Text('Group: ${_groupNameController.text}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class ActiveUsersScreen extends StatelessWidget {
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
