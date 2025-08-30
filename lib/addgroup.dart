import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AddGroupFormScreen extends StatefulWidget {
  const AddGroupFormScreen({super.key});

  @override
  State<AddGroupFormScreen> createState() => _AddGroupFormScreenState();
}

class _AddGroupFormScreenState extends State<AddGroupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _dept = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _bottomRightLat = TextEditingController();
  final TextEditingController _bottomRightLng = TextEditingController();
  final TextEditingController _topLeftLat = TextEditingController();
  final TextEditingController _topLeftLng = TextEditingController();
  final TextEditingController _profilepic = TextEditingController();

  Future<bool> _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final hasInternet = await _checkInternet();
    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No internet connection")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('userdetails').add({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'password': _password.text.trim(),
        'age': int.parse(_age.text.trim()),
        'dept': _dept.text.trim(),
        'designation': _designation.text.trim(),
        'phone': int.parse(_phone.text.trim()),
        'address': _address.text.trim(),
        'bottomRightLat': double.parse(_bottomRightLat.text.trim()),
        'bottomRightLng': double.parse(_bottomRightLng.text.trim()),
        'topLeftLat': double.parse(_topLeftLat.text.trim()),
        'topLeftLng': double.parse(_topLeftLng.text.trim()),
        'profilepic': _profilepic.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully!'),backgroundColor: Colors.green,),
      );
      _formKey.currentState?.reset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool isNumber = false,
    bool isDecimal = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isDecimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : isNumber
                ? TextInputType.number
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.green,
          ), // Added icon for visual appeal
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return "$label is required";
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Invalid email";
          if (isNumber && int.tryParse(value.trim()) == null) return "Enter valid number";
          if (isDecimal && double.tryParse(value.trim()) == null) return "Enter valid decimal";
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _age.dispose();
    _dept.dispose();
    _designation.dispose();
    _phone.dispose();
    _address.dispose();
    _bottomRightLat.dispose();
    _bottomRightLng.dispose();
    _topLeftLat.dispose();
    _topLeftLng.dispose();
    _profilepic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Name", _name),
              _buildTextField("Email", _email, isEmail: true),
              _buildTextField("Password", _password, isPassword: true),
              _buildTextField("Age", _age, isNumber: true),
              _buildTextField("Department", _dept),
              _buildTextField("Designation", _designation),
              _buildTextField("Phone", _phone, isNumber: true),
              _buildTextField("Address", _address),
              _buildTextField("Top Left Latitude", _topLeftLat, isDecimal: true),
              _buildTextField("Top Left Longitude", _topLeftLng, isDecimal: true),
              _buildTextField("Bottom Right Latitude", _bottomRightLat, isDecimal: true),
              _buildTextField("Bottom Right Longitude", _bottomRightLng, isDecimal: true),
              _buildTextField("Profile Pic ID", _profilepic),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: Colors.green, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Register ", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 30),
              const Text(
                'Registering with us gives you the better experience! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
