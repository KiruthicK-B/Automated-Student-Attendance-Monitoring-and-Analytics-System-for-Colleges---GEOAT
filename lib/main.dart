// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
//import 'package:flutter/services.dart';
import 'home.dart';
import 'index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
       
        '/tickscreen': (context) => const TickAnimation(message: 'Login Successfull',),
       // '/signup': (context) => const SignUpScreen(),
        '/index': (context) => const IndexScreen(),
        '/admin': (context) => const HomeScreen_2(),

      },
    );
  }
}

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Index Screen'),
      ),
      body: const Center(
        child: Text('This is the Index Screen'),
      ),
    );
  }
}


// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: duplicate_ignore
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a timer to navigate to the next screen after 1 second
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/Splash3.png', // Replace with your logo asset
              width: 1000,
              height: 1000,
            ),
          ),
          // Add a spinner at the center
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                SizedBox(height: 30), // Space between spinner and bottom of the screen
                Text('Loading...', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Onboarding Screen
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          OnboardingPage1(),
          OnboardingPage2(),
        ],
      ),
    );
  }
}

// First Onboarding Page
class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/onboarding_image.png', // Replace with your image
                  height: MediaQuery.of(context).size.height * 0.4, // Dynamic size
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to GeoAt!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Track and manage attendance with real-time location verification.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, // Adjust this based on the design
            right: 16,
            child: TextButton(
              onPressed: () {
                // Skip action, navigate directly to login page
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 40, // Adjust based on design
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the next onboarding page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingPage2()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

// Second Onboarding Page
class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  _OnboardingPage2State createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  bool isLocationEnabled = true; // Simulating location status

  // Function to check if location services are enabled
  void checkLocationService() {
    // Placeholder logic: replace this with actual location checking logic
    if (!isLocationEnabled) {
      showLocationAlert();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Alert user to turn on location services
  void showLocationAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text(
          "Please enable location services to continue with attendance verification.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/geoat_earth.png',
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Location Verification",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We need to access your location to verify your attendance.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: TextButton(
              onPressed: () {
                // Skip action, navigate directly to login page
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: checkLocationService, // Check location status on button press
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
Future<void> loginUser(bool isAdmin) async {
  setState(() {
    isLoading = true;
  });

  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  print("📩 Attempting Firestore Login - Email: $email");

  try {
    // 🔍 Query Firestore for the user
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userdetails')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("❌ Login Failed: User not found in Firestore");
      showError("User not found. Please check your email.");
    } else {
      var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      String storedPassword = userData['password'].toString();

      print("🔐 User Found: ${userData['name']}, Stored Password: $storedPassword");

      if (storedPassword == password) {
        print("✅ Login Successful for ${userData['name']} (Admin: $isAdmin)");

        Navigator.pushNamed(
          context,
          '/tickscreen',
          arguments: {
            'isAdmin': isAdmin,
            'name': userData['name'],
            'email': userData['email'],
          },
        );
      } else {
        print("❌ Incorrect password entered");
        showError("Incorrect password. Please try again.");
      }
    }
  } on SocketException {
    print("⚠️ Network Error: No Internet Connection");
    showError("No internet connection. Please try again.");
  } catch (e) {
    print("⚠️ Unexpected Error: $e");
    showError("Something went wrong. Please try again.");
  }

  setState(() {
    isLoading = false;
  });
}

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/Splash2.png', // Replace with your logo asset
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 30),

              // Email Input
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Password Input
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => loginUser(false), // User Login
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'User Login',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => loginUser(true), // Admin Login
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Admin Login',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 40),
              const Text(
                "Don't know about us? Help",
                style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(thickness: 1),
            Text(
              " support@geoat.com | Terms & Conditions | ©2024 All Rights Reserved",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class TickAnimation extends StatefulWidget {
  const TickAnimation({super.key, required this.message});
  final String message;

  @override
  _TickAnimationState createState() => _TickAnimationState();
}

class _TickAnimationState extends State<TickAnimation> {
  late bool isAdmin;
  late String userName;
  late String userEmail;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      isAdmin = args?['isAdmin'] ?? false;
      userName = args?['name'] ?? 'User';
      userEmail = args?['email'] ?? '';
      
      print('✅ TickAnimation: Received email: $userEmail');

      // ✅ Optional: slight delay to show tick animation
      await Future.delayed(const Duration(seconds: 2));

      // 👉 Navigate to the right home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isAdmin
              ? const HomeScreen_2()
              : HomeScreen(userName: userName, userEmail: userEmail),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Login Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
