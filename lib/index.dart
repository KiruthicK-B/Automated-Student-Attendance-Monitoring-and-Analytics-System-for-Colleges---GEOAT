
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geoat_back/FinalScreen.dart';
import 'package:geoat_back/main.dart';
import 'package:geoat_back/mapscreen.dart';
import 'ProfileScreen.dart';
import 'RecordScreen.dart';
import 'myactivity.dart';
import 'task.dart';
import 'package:geolocator/geolocator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TickAnimation(message: 'Welcome!'),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isChatbotOpen = false;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  String currentLocation = "Banglore, India";
  String currentTemperature = "22°C";
  String userName = "Kiruthick B";
  List<String> tasks = ["Complete project report", "Team meeting at 2 PM"];
  int pendingTasks = 2;
  late String userEmail;

  late List<Widget> _pages;
  late String loginEmail;
  @override
  void initState() {
    super.initState();
    userEmail = widget.userEmail.trim();

    loginEmail = widget.userEmail.trim();
    print("✅ HomeScreen received email: $loginEmail");
    print("✅ HomeScreen received email: ${widget.userEmail}");
    _pages = [
      HomeContent(userName: widget.userName, userEmail: userEmail),
      RecordScreen(userName: widget.userName, userEmail: userEmail),
      MapScreen(userName: widget.userName, userEmail: userEmail),
      ProfileScreen(userName: widget.userName, userEmail: userEmail),
      ProfileEditScreen(userName: widget.userName, userEmail: userEmail),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleChatbot() {
    setState(() {
      _isChatbotOpen = !_isChatbotOpen;
    });
  }

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      String question = _chatController.text;
      String answer = _getChatbotResponse(question);
      setState(() {
        _chatHistory.add({'question': question, 'answer': answer});
        _chatController.clear();
      });
    }
  }

  String _getChatbotResponse(String question) {
    try {
      question =
          question
              .toLowerCase(); // Convert question to lowercase for easier matching

      if (question.contains("date")) {
        return DateFormat.yMMMMd().format(
          DateTime.now(),
        ); // Returns current date
      } else if (question.contains("time")) {
        return DateFormat.jm().format(DateTime.now()); // Returns current time
      } else if (question.contains("location")) {
        return currentLocation; // Returns current location
      } else if (question.contains("temperature")) {
        return currentTemperature; // Returns current temperature
      } else if (question.contains("schedule")) {
        return tasks.isEmpty
            ? "You have no tasks today!"
            : "Tasks for today: ${tasks.join(', ')}";
      } else if (question.contains("pending tasks")) {
        return pendingTasks == 0
            ? "No pending tasks."
            : "You have $pendingTasks pending tasks.";
      } else if (question.contains("check in")) {
        return "Yes, you can check in now!";
      } else if (question.contains("who am i")) {
        return "You are logged in as $userName.";
      } else if (question.contains("email")) {
        return "Your email is $userEmail.";
      } else if (question.contains("tasks left")) {
        return pendingTasks == 0
            ? "No tasks left."
            : "You have $pendingTasks tasks left.";
      } else {
        return "Sorry, I didn’t understand that. Please ask something else.";
      }
    } catch (e) {
      return "An error occurred while processing your request. Please try again.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6AB547),
        elevation: 0,
        toolbarHeight: 120,
        automaticallyImplyLeading: false, // This removes the back arrow
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Current location and date/time details
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Banglore, India",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Thu, 17 Apr 2025 ", // Add dynamic date and time if needed
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Weather and notification icon
                  Row(
                    children: [
                      Column(
                        children: const [
                          Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                            size: 24,
                          ), // Weather icon
                          Text("26°C", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), // Reduced border radius
            bottomRight: Radius.circular(10), // Reduced border radius
          ),
        ),
      ),
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (_isChatbotOpen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _chatHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_chatHistory[index]['question']!),
                          subtitle: Text(_chatHistory[index]['answer']!),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            decoration: const InputDecoration(
                              hintText: 'Ask a question...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Add a new row for the button and center it
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _sendMessage,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(
                              0xFF6AB547,
                            ), // Text color
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 10.0,
                            ), // Adjust padding as needed
                          ),
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleChatbot,
        child: const Icon(Icons.smart_toy),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF6AB547),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Record',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

extension on Function(String s) {
  yMMMMd() {}

  jm() {}
}

// ignore: use_key_in_widget_constructor
class HomeScreenState extends StatelessWidget {
  const HomeScreenState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF6AB547),
      ),
      body: HomeContent(
        userName: "John Doe", // Replace with dynamic user data
        userEmail: "john@example.com", // Replace with dynamic user email
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final String userName;
  final String userEmail;

  const HomeContent({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  get loginEmail => userEmail;

  @override
  // ignore: library_private_types_in_public_api
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, String>> tasks = [];

  // Callback function to add a new task
  void addNewTask(Map<String, String> task) {
    setState(() {
      tasks.add(task);
    });
  }

  // Function to delete a task
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.userName}!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 20),

            // Profile image
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage(
                  'assets/profile.jpeg',
                ), // Add profile image
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 20),

            // Task prompt
            const Text(
              "Today’s Tasks",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Displaying tasks or a message if there are no tasks
            tasks.isEmpty
                ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "You have no pending tasks. Great job staying up-to-date!",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Align(
                              alignment:
                                  Alignment
                                      .center, // Align to center vertically
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to AddTaskPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => AddTaskPage(
                                            onTaskAdded: addNewTask,
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.all(10),
                                  shape: const CircleBorder(),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
                : Column(
                  children: [
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(tasks[index]['title']!),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            deleteTask(index);
                          },
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text(tasks[index]['title']!),
                              subtitle: Text(
                                "${tasks[index]['deadline']} - Priority: ${tasks[index]['priority']}",
                              ),
                              trailing: Row(
                                mainAxisSize:
                                    MainAxisSize
                                        .min, // To make the row as small as possible
                                children: [
                                  // Add task button (+ symbol)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      // Handle task addition
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => AddTaskPage(
                                                onTaskAdded: addNewTask,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Delete task button
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deleteTask(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
            const SizedBox(height: 20), // Check-in button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final loginEmail = widget.userEmail;
                    print(
                      "📩 Email used for Firestore query: ${widget.userEmail}",
                    );

                    if (loginEmail.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('❗ Email is empty.')),
                      );
                      return;
                    }

                    final userDoc =
                        await FirebaseFirestore.instance
                            .collection('userdetails')
                            .where('email', isEqualTo: loginEmail)
                            .limit(1)
                            .get();

                    if (userDoc.docs.isNotEmpty) {
                      final userData = userDoc.docs.first.data();
                      final userEmail = userData['email'];

                      print("✅ Firestore document found: $userEmail");

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoadingScreen(),
                          settings: RouteSettings(
                            arguments: {'email': userEmail},
                          ),
                        ),
                      );
                    } else {
                      print("❌ No matching document found.");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ User email not found in Firestore.'),
                        ),
                      );
                    }
                  } catch (e) {
                    print("🔥 ERROR during Firestore query: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6AB547),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 50.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Check In',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, size: 24, color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'My Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add navigation code to Get Permission page here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Need help?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Great things are done by taking small steps every day. Let’s make today count!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
DateFormat(String s) {}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('email')) {
        userEmail = args['email'];
        verifyLocation(); // Start location verification
      } else {
        showErrorAndGoBack("No email argument provided.");
      }
    });
  }

  Future<void> verifyLocation() async {
    try {
      // Request location permission if not granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          showErrorAndGoBack("Location permission is required.");
          return;
        }
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double userLat = position.latitude;
      double userLng = position.longitude;

      print("📍 Current Location: Lat=$userLat, Lng=$userLng");

      // Fetch user document by email
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('userdetails')
              .where('email', isEqualTo: userEmail)
             
              .get();

      if (querySnapshot.docs.isEmpty) {
        showErrorAndGoBack("User not found in Firestore.");
        return;
      }

      final userData = querySnapshot.docs.first.data();
     
      print("User data: $userData");

      // Check for required location fields
      if (!userData.containsKey("topLeftLat") ||
          !userData.containsKey("topLeftLng") ||
          !userData.containsKey("bottomRightLat") ||
          !userData.containsKey("bottomRightLng")) {
        showErrorAndGoBack("Location details not found for this user.");
        return;
      }

      double topLeftLat = userData["topLeftLat"];
      double topLeftLng = userData["topLeftLng"];
      double bottomRightLat = userData["bottomRightLat"];
      double bottomRightLng = userData["bottomRightLng"];

      print(
        "📦 Firebase Bounds: Top Left($topLeftLat, $topLeftLng), Bottom Right($bottomRightLat, $bottomRightLng)",
      );

      // Location match check
      bool isInside =
          userLat <= topLeftLat &&
          userLat >= bottomRightLat &&
          userLng >= topLeftLng &&
          userLng <= bottomRightLng;

      if (isInside) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FinalScreen(email: userEmail),
          ),
        );
      } else {
        showErrorAndGoBack("You're outside the allowed location boundary.");
      }
    } catch (e) {
      print("❌ Error verifying location: $e");
      showErrorAndGoBack("Error verifying location: $e");
    }
  }

  void showErrorAndGoBack(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );

    // Pop screen immediately after showing the snackbar
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Verifying Location...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
