

import 'package:flutter/material.dart';
class AddTaskPage extends StatefulWidget {
  final Function(Map<String, String>) onTaskAdded;

  const AddTaskPage({super.key, required this.onTaskAdded});

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String taskTitle = '';
  String deadline = '';
  String priority = 'Low';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: const Color(0xFF6AB547),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onSaved: (value) {
                  taskTitle = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Deadline'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deadline';
                  }
                  return null;
                },
                onSaved: (value) {
                  deadline = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Priority'),
                value: priority,
                items: const [
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'High', child: Text('High')),
                ],
                onChanged: (value) {
                  setState(() {
                    priority = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onTaskAdded({
                      'title': taskTitle,
                      'deadline': deadline,
                      'priority': priority,
                    });
                    Navigator.pop(context); // Go back to task list
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 20),
                ),
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

