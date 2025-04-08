// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'main.dart'; // Ensure you import your admin page

// // Sign in screen
// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   bool _rememberMe = false; // State variable for the checkbox
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // Error message state variables
//   String? _emailError;
//   String? _passwordError;

//   @override
//   Widget build(BuildContext context) {
//     // Retrieve the 'isAdmin' flag from arguments
//     final args = ModalRoute.of(context)!.settings.arguments as Map<String, bool>?;
//     final isAdmin = args?['isAdmin'] ?? false;

//     return Scaffold(
//       appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo Section
//                 Center(
//                   child: Image.asset(
//                     'assets/Splash2.png', // Replace with your logo asset
//                     height: 150,
//                     width: 150,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Welcome Text
//                 const Text(
//                   'Welcome Back!',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   isAdmin ? 'Admin Login' : 'Log in to your account',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 30),

//                 // Email Field
//                 TextField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     prefixIcon: const Icon(Icons.email),
//                     border: const OutlineInputBorder(),
//                     errorText: _emailError, // Display error message
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Password Field
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: const Icon(Icons.lock),
//                     border: const OutlineInputBorder(),
//                     errorText: _passwordError, // Display error message
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // "Remember Me" and "Forgot Password?" Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _rememberMe, // Use the state variable
//                           onChanged: (bool? value) {
//                             setState(() {
//                               _rememberMe = value ?? false; // Update state
//                             });
//                           },
//                         ),
//                         const Text('Remember Me'),
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // Handle Forgot Password action
//                       },
//                       child: const Text(
//                         'Forgot Password?',
//                         style: TextStyle(color: Colors.green),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Login Button
//                 ElevatedButton(
//                   onPressed: () {
//                     // Clear previous error messages
//                     setState(() {
//                       _emailError = null;
//                       _passwordError = null;
//                     });

//                     // Perform validation
//                     if (_emailController.text.isEmpty) {
//                       setState(() {
//                         _emailError = 'Email is required';
//                       });
//                     }
//                     if (_passwordController.text.isEmpty) {
//                       setState(() {
//                         _passwordError = 'Password is required';
//                       });
//                     }

//                     // Admin-specific login
//                     if (isAdmin) {
//                       if (_emailController.text == 'admin' && _passwordController.text == 'admin123') {
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen_2(),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Invalid admin credentials')),
//                         );
//                       }
//                     } 
//                     // Regular user login
//                     else if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(
//                           builder: (context) => const TickAnimation(message: 'Login Successful'),
//                         ),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   child: const Text(
//                     'Log In',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // "Don't have an account?" and Register Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     // Uncomment if you have a registration page
//                     // Text("Don't have an account?"),
//                     // TextButton(
//                     //   onPressed: () {
//                     //     Navigator.pushNamed(context, '/signup');
//                     //   },
//                     //   child: Text('Register', style: TextStyle(color: Colors.green)),
//                     // ),
//                   ],
//                 ),
//                 const SizedBox(height: 40),

//                 // Footer Section
//                 Column(
//                   children: [
//                     const Text(
//                       'Contact: support@geoat.com',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 8),
//                     TextButton(
//                       onPressed: () {
//                         // Handle Terms & Conditions action
//                       },
//                       child: const Text(
//                         'Terms & Conditions',
//                         style: TextStyle(
//                           color: Colors.green, 
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       '© 2024 All Rights Reserved',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
