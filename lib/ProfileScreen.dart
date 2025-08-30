import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geoat_back/main.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFAQExpanded = false;
  bool _isFullProfile = false;
  final TextEditingController _feedbackController = TextEditingController();
  Map<String, dynamic>? userData;

  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isFetching = true);

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection");
      }

      final usersRef = FirebaseFirestore.instance.collection('userdetails');
      final snapshot = await usersRef.get();

      // Loop through to find the UID with matching email
      for (var doc in snapshot.docs) {
        if (doc.data()['email'] == widget.userEmail) {
          userData = doc.data();
          debugPrint("Fetched User Data: $userData"); // ✅ Debug Print
          break;
        }
      }

      if (userData == null) {
        throw Exception("User not found");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() => _isFetching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                        builder: (context) => const ProfileEditScreen(
                          userName: '',
                          userEmail: '',
                        ),
                      ));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              userData?['name'] ?? widget.userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(widget.userEmail),
            Text("Phone: ${userData?['phone'] ?? 'Loading...'}"),
            const SizedBox(height: 10),

            if (_isFullProfile) ...[
              Text('Age: ${userData?['age'] ?? 'Loading...'}'),
              Text('Designation: ${userData?['designation'] ?? 'Loading...'}'),
              Text('Department: ${userData?['dept'] ?? 'Loading...'}'),
              Text('Address: ${userData?['address'] ?? 'Loading...'}'),
            ],

            TextButton(
              onPressed: () => setState(() => _isFullProfile = !_isFullProfile),
              child: Text(
                _isFullProfile ? 'Show Less' : 'View Full Profile',
                style: const TextStyle(color: Colors.green),
              ),
            ),

            const SizedBox(height: 20),
            if (_isFetching)
              const CircularProgressIndicator()
            else
              _buildFAQSection(),

            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(Icons.info, color: Colors.green),
              title: Text("About Us"),
              subtitle: Text(
                  "Our company offers cutting-edge technology solutions aimed at improving your workflow and life."),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              label: const Text('Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),

            const SizedBox(height: 30),
            Column(
              children: const [
                Text('Contact: support@example.com', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text('Terms & Conditions', style: TextStyle(color: Colors.green)),
                SizedBox(height: 8),
                Text('© 2024 Rights Reserved', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() => _isFAQExpanded = !_isFAQExpanded);
      },
      children: [
        ExpansionPanel(
          isExpanded: _isFAQExpanded,
          headerBuilder: (_, __) => const ListTile(title: Text("Have Queries?")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Select Category'),
                  items: const [
                    DropdownMenuItem(value: 'account', child: Text('Account Issues')),
                    DropdownMenuItem(value: 'feedback', child: Text('App Feedback')),
                    DropdownMenuItem(value: 'other', child: Text('Other Queries')),
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
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmitFeedback() async {
    String feedback = _feedbackController.text.trim();

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your feedback or query")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Submitting feedback..."),
          ],
        ),
      ),
    );

    try {
      final usersRef = FirebaseFirestore.instance.collection('userdetails');
      final snapshot = await usersRef.get();

      for (var doc in snapshot.docs) {
        if (doc.data()['email'] == widget.userEmail) {
          await doc.reference.update({
            'queries': FieldValue.arrayUnion([
              {
                'message': feedback,
               
              }
            ])
          });
          break;
        }
      }

      Navigator.of(context).pop();
      _feedbackController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully"), backgroundColor: Colors.green,),
        
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: const Color.fromARGB(255, 251, 3, 3),),
      );
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Logging Out..."),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }
}


// Placeholder Edit Profile Screen

class ProfileEditScreen extends StatefulWidget {
   final String userName;
  final String userEmail;
  const ProfileEditScreen({super.key, required this.userName, required this.userEmail});

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