import 'package:flutter/material.dart';

import 'navbar.dart'; // Your navigation drawer import

// ignore: camel_case_types
class HomeScreen_2 extends StatelessWidget {
   final String userName;
  final String userEmail;
  const HomeScreen_2({super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: const AppNavigationDrawer(userName: '', userEmail: '',), // Navigation Drawer
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
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Quick Stats Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Total Users', '150', Colors.blue),
                  _buildStatCard('Active Users', '123', Colors.green),
                  _buildStatCard('Groups', '10', Colors.orange),
                ],
              ),
              const SizedBox(height: 20),

              // Action Buttons (Quick Links)
              Text(
                'Quick Links',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.person,
                    label: 'Manage Users',
                    color: Colors.teal,
                    onTap: () {
                      // Navigate to Manage Users
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.group,
                    label: 'Manage Groups',
                    color: Colors.blue,
                    onTap: () {
                      // Navigate to Manage Groups
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.location_on,
                    label: 'Set Coordinates',
                    color: Colors.orange,
                    onTap: () {
                      // Navigate to Set Coordinates
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recent Activity
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildRecentActivityList(),

              const SizedBox(height: 20),

              // Analytics Overview Placeholder
              Text(
                'Analytics Overview',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
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

  // Widget for a quick stat card
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

  // Widget for an action button with icon and label
  Widget _buildActionButton({
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
              Icon(icon, color: color, size: 30),
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

  // Widget for the recent activity list
  Widget _buildRecentActivityList() {
    final List<Map<String, String>> recentActivities = [
      {'title': 'User checked in', 'subtitle': 'At 10:00 AM'},
      {'title': 'New group created', 'subtitle': 'Team Alpha'},
      {'title': 'Coordinates updated', 'subtitle': 'Head Office'},
      {'title': 'User added', 'subtitle': 'John Doe to Team Beta'},
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
}
