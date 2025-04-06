// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'addgroup.dart';
import 'navbar.dart'; // Ensure this is your AppNavigationDrawer

class GroupsScreen extends StatefulWidget {
  final String groupName;
  final String totalMembers;
  final Color color;

  const GroupsScreen({
    super.key,
    required this.groupName,
    required this.totalMembers,
    required this.color,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<String> users = ['User1', 'User2', 'User3']; // Sample users list

  void _addUser() {
    setState(() {
      users.add('New User ${users.length + 1}');
    });
  }

  void _deleteGroup(BuildContext context) {
    // Confirmation dialog for deleting the group
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Group'),
        content: Text('Are you sure you want to delete this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Close the group screen
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addGroup() {
    // Logic for adding a new group (e.g., navigating to a form screen)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddGroupFormScreen(), // Replace with your AddGroupFormScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group: ${widget.groupName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addUser,
            tooltip: 'Add User',
          ),
          IconButton(
            icon: Icon(Icons.group_add),
            onPressed: _addGroup,
            tooltip: 'Add Group',
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteGroup(context),
            tooltip: 'Delete Group',
          ),
        ],
      ),
      drawer: const AppNavigationDrawer(), // Add the drawer here
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.groupName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Members: ${widget.totalMembers}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Divider(),
              Text(
                'Group Members:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(users[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy AddGroupFormScreen for navigation purposes

