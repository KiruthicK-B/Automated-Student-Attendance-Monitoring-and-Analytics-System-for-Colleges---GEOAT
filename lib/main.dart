// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:flutter/services.dart';
import 'SigninScreen.dart';
import 'home.dart';
import 'index.dart';

void main() {
  runApp(const MyApp());
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
        '/signin': (context) => const SignInScreen(),
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


// Login Screen
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Minimize column height to content
            children: [
              Image.asset(
                'assets/Splash2.png', // Replace with your logo asset
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate to User Sign-in page
                  Navigator.pushNamed(context, '/signin', arguments: {'isAdmin': false});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'User Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Admin Sign-in page
                  Navigator.pushNamed(context, '/signin', arguments: {'isAdmin': true});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Admin Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Don't know about us? Help",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
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


// Sign-up Screen
// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns content between top and bottom
//           children: [
//             // Logo at the top
//             Column(
//               children: [
//                 Image.asset(
//                   'assets/Splash2.png', // Replace with your logo asset
//                   height: 180,
//                   width: 180,
//                 ),
//               ],
//             ),

//             // Form fields
//             Column(
//               children: [
//                 const TextField(
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                     prefixIcon: Icon(Icons.person),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const TextField(
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     prefixIcon: Icon(Icons.email),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Confirm Password',
//                     prefixIcon: Icon(Icons.lock),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to the VerificationScreen when the button is pressed
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const VerificationScreen()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text('Sign Up'),
//                 ),
//               ],
//             ),

//             // Footer content
//             Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Column(
//                 children: [
//                   const Text(
//                     'By signing up, you agree to our Terms & Conditions',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   const SizedBox(height: 10),
//                   GestureDetector(
//                     onTap: () {
//                       // Handle privacy policy tap
//                     },
//                     child: const Text(
//                       'Privacy Policy',
//                       style: TextStyle(
//                         decoration: TextDecoration.underline,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class TickAnimation extends StatefulWidget {
  const TickAnimation({super.key, required String message});

  @override
  _TickAnimationState createState() => _TickAnimationState();
}

class _TickAnimationState extends State<TickAnimation> {
  @override
  void initState() {
    super.initState();
    
    // Start a 5-second timer and navigate to the HomeScreen (index.dart)
    Future.delayed(const Duration(seconds: 2), () {
      // After 5 seconds, navigate to the HomeScreen from index.dart
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Ensure HomeScreen is in index.dart
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