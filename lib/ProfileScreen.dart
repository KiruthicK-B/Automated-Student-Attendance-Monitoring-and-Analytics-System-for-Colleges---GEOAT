import 'package:flutter/material.dart';
import 'SigninScreen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFAQExpanded = false;
  bool _isSettingsExpanded = false;
  bool _isFullProfile = false;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/HomeScreen'); // Back to homepage
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          //title: const Text("Profile"),
          automaticallyImplyLeading: false, // Prevents back arrow from appearing
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.jpeg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Kiruthick B',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('kiruthick@gmail.com'),
              const SizedBox(height: 5),
              const Text('Phone: +91 9342696026'),
              const SizedBox(height: 10),
              if (_isFullProfile) ...[
                const Text('Age: 20'),
                const SizedBox(height: 5),
                const Text('Designation: Software Engineer'),
                const SizedBox(height: 5),
                const Text('Department: IT'),
                const SizedBox(height: 5),
                const Text('Address: 123, Tech Avenue, Chennai'),
              ],
              TextButton(
                onPressed: () =>
                    setState(() => _isFullProfile = !_isFullProfile),
                child: Text(_isFullProfile ? 'Show Less' : 'View Full Profile',
                    style: const TextStyle(color: Colors.green)),
              ),
              const SizedBox(height: 20),

              // FAQ Section with Categories
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isFAQExpanded = !_isFAQExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(title: Text("Have Queries?"));
                    },
                    body: Column(
                      children: [
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                              labelText: 'Select Category'),
                          items: const [
                            DropdownMenuItem(
                                value: 'account',
                                child: Text('Account Issues')),
                            DropdownMenuItem(
                                value: 'feedback',
                                child: Text('App Feedback')),
                            DropdownMenuItem(
                                value: 'other',
                                child: Text('Other Queries')),
                          ],
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _feedbackController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Your Query or Feedback',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _handleSubmitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6AB547),
                            padding: const EdgeInsets.symmetric(
                                vertical: 9.0, horizontal: 50.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('Submit',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                    isExpanded: _isFAQExpanded,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Expanded Settings with Additional Features
             ExpansionPanelList(
  expansionCallback: (int index, bool isExpanded) {
    setState(() {
      _isSettingsExpanded = !_isSettingsExpanded;
    });
  },
  children: [
    ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return const ListTile(title: Text("Settings"));
      },
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Account Security"),
            onTap: () {
              // Implement security settings logic here
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Account Security'),
                  content: const Text('Manage your security settings here.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text("Linked Devices"),
            onTap: () {
              // Logic to manage linked devices
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Linked Devices'),
                  content: const Text('Manage your linked devices here.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("App Permissions"),
            onTap: () {
              // Permissions toggle logic
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  bool cameraPermission = true;  // Example: initial state
                  bool locationPermission = false;
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Camera'),
                            value: cameraPermission,
                            onChanged: (bool value) {
                              setState(() {
                                cameraPermission = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Location'),
                            value: locationPermission,
                            onChanged: (bool value) {
                              setState(() {
                                locationPermission = value;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Theme Settings"),
            onTap: () {
              // Logic for selecting theme
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  String themeChoice = 'System Default';
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Light'),
                            value: 'Light',
                            groupValue: themeChoice,
                            onChanged: (value) {
                              setState(() {
                                themeChoice = value!;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Dark'),
                            value: 'Dark',
                            groupValue: themeChoice,
                            onChanged: (value) {
                              setState(() {
                                themeChoice = value!;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('System Default'),
                            value: 'System Default',
                            groupValue: themeChoice,
                            onChanged: (value) {
                              setState(() {
                                themeChoice = value!;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Apply'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language Preferences"),
            onTap: () {
              // Logic for language selection
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  String selectedLanguage = 'English';
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('English(UK)'),
                            value: 'English',
                            groupValue: selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('English(US)'),
                            value: 'Spanish',
                            groupValue: selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Hindi'),
                            value: 'French',
                            groupValue: selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Apply'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      isExpanded: _isSettingsExpanded,
    ),
  ],
),


              // About Us
              const ListTile(
                leading: Icon(Icons.info, color: Colors.green),
                title: Text("About Us"),
                subtitle: Text(
                  "Our company offers cutting-edge technology solutions aimed at improving your workflow and life.",
                ),
              ),
              const SizedBox(height: 20),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                label: const Text('Logout',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              const SizedBox(height: 30),

              // Footer Section
              Column(
                children: const [
                  Text('Contact: support@example.com',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Terms & Conditions',
                      style: TextStyle(color: Colors.green)),
                  SizedBox(height: 8),
                  Text('© 2024 Rights Reserved',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmitFeedback() {
    String feedback = _feedbackController.text;

    // Validate feedback input
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your feedback or query")),
      );
      return;
    }

    // Show loading dialog for submitting feedback
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Submitting feedback..."),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      // Close the dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully")),
      );

      // Clear the feedback input field
      _feedbackController.clear();
    });
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Logging Out..."),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      // Close the dialog
      Navigator.of(context).pop();

      // Navigate back to the ProfileScreen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ));
    });
  }
}

// Placeholder Edit Profile Screen

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  // Function to simulate saving the changes
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Saving changes..."),
              ],
            ),
          );
        },
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Your changes have been submitted to the admin."),
        ));
        Navigator.pop(context); // Go back to profile screen
      });
    }
  }

  String? _validateEmail(String? value) {
    const String pattern =
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$'; // Basic email pattern
    final RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    const String pattern = r'^\d{10}$'; // Pattern for a 10-digit phone number
    final RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    final int? age = int.tryParse(value);
    if (age == null || age <= 0) {
      return 'Enter a valid age';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF6AB547),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign the form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit your details here...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail, // Use custom email validation
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePhone, // Use custom phone validation
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number, // Numeric input for age
                  validator: _validateAge, // Use custom age validation
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _designationController,
                  decoration: const InputDecoration(
                    labelText: 'Designation',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your designation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                // Save and Close buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close without saving
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: const Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: _saveChanges, // Save changes with validation
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6AB547),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}