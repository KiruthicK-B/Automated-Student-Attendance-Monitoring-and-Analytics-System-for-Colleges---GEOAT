import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddGroupFormScreen(),
    );
  }
}

class AddGroupFormScreen extends StatefulWidget {
  const AddGroupFormScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddGroupFormScreenState createState() => _AddGroupFormScreenState();
}

class _AddGroupFormScreenState extends State<AddGroupFormScreen> {
  bool? _isSameOrganization;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _totalMembersController = TextEditingController();
  final TextEditingController _organizationNameController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _adminsController = TextEditingController();

  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Name Field
                TextFormField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(labelText: 'Group name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Group name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Total Members Field
                TextFormField(
                  controller: _totalMembersController,
                  decoration: const InputDecoration(labelText: 'Total Members'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Total Members is required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Organization Radio Buttons
                const Text('Under Same Organization:'),
                Row(
                  children: [
                    Radio<bool?>(
                      value: true,
                      groupValue: _isSameOrganization,
                      onChanged: (bool? value) {
                        setState(() {
                          _isSameOrganization = value;
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<bool?>(
                      value: false,
                      groupValue: _isSameOrganization,
                      onChanged: (bool? value) {
                        setState(() {
                          _isSameOrganization = value;
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
                const SizedBox(height: 16),

                // Organization Name and Purpose Fields
                TextFormField(
                  controller: _organizationNameController,
                  decoration: const InputDecoration(labelText: 'Organization Name'),
                  enabled: _isSameOrganization == false,
                  validator: (value) {
                    if (_isSameOrganization == false && (value == null || value.isEmpty)) {
                      return 'Organization Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                  enabled: _isSameOrganization == false,
                  maxLines: 3,
                  validator: (value) {
                    if (_isSameOrganization == false && (value == null || value.isEmpty)) {
                      return 'Purpose is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Admins Field with basic email validation
                TextFormField(
                  controller: _adminsController,
                  decoration: const InputDecoration(
                    labelText: 'Add other Admins',
                    hintText: 'admin1@gmail.com, admin2@gmail.com',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emails = value.split(',').map((e) => e.trim());
                      for (var email in emails) {
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                          return 'Enter valid email addresses';
                        }
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Color Selection with visual indicator
                const Text('Select color:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColorOption(Colors.red),
                    _buildColorOption(Colors.pink),
                    _buildColorOption(Colors.blue),
                    _buildColorOption(Colors.green),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Display loading indicator before submission
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        // Simulate a network call with a delay
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pop(context); // close the loading dialog
                          GroupsScreen.groups.add(
                            Group(
                              groupName: _groupNameController.text,
                              totalMembers: _totalMembersController.text,
                              color: _selectedColor ?? Colors.grey,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GroupsScreen(),
                            ),
                          );
                        });
                      }
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
        height: 30,
        width: 30,
      ),
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _totalMembersController.dispose();
    _organizationNameController.dispose();
    _purposeController.dispose();
    _adminsController.dispose();
    super.dispose();
  }
}

// Group and GroupsScreen classes
class Group {
  final String groupName;
  final String totalMembers;
  final Color color;

  Group({required this.groupName, required this.totalMembers, required this.color});
}

class GroupsScreen extends StatelessWidget {
  static List<Group> groups = [];

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Card(
            color: group.color.withOpacity(0.2),
            child: ListTile(
              title: Text(group.groupName, style: TextStyle(color: group.color)),
              subtitle: Text('Total Members: ${group.totalMembers}'),
            ),
          );
        },
      ),
    );
  }
}
