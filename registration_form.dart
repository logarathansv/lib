import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sklyit_business/main.dart'; // For Google sign-in functionality

class AdminRegistrationForm extends StatefulWidget {
  const AdminRegistrationForm({Key? key}) : super(key: key);

  @override
  State<AdminRegistrationForm> createState() => _AdminRegistrationFormState();
}

class _AdminRegistrationFormState extends State<AdminRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to collect form input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender; // Gender Dropdown
  final List<String> genders = ["Male", "Female", "Other"];

  void _navigateToBusinessForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SklyitApp(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildInputField("Name", _nameController),
                _buildInputField("Date of Birth", _dobController,
                    inputType: TextInputType.datetime),
                _buildInputField("Phone Number", _phoneController,
                    inputType: TextInputType.phone),
                _buildEmailField("Email", _emailController),
                _buildDropdown("Gender", genders, _selectedGender, (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                }),
                _buildInputField("Address", _addressController, maxLines: 2),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToBusinessForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Next: Business Registration'),
                  ),
                ),
                const Divider(height: 40, thickness: 1),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            hint: Text("Select $label"),
            onChanged: onChanged,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    // Placeholder for Google sign-in logic
  }
}
