import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController(); // Format: YYYY-MM-DD
  final _mobileController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressDoorController = TextEditingController();
  final _addressStreetController = TextEditingController();
  final _addressCityController = TextEditingController();
  final _addressStateController = TextEditingController();
  final _addressPincodeController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _profileImage; // For storing the selected image
  final _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to submit the form
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        var uri = Uri.parse('http://your-backend-url/users/register');
        var request = http.MultipartRequest('POST', uri);

        // Adding form data
        request.fields['name'] = _nameController.text;
        request.fields['gmail'] = _emailController.text;
        request.fields['dob'] = _dobController.text;
        request.fields['mobileno'] = _mobileController.text;
        request.fields['wtappNo'] = _whatsappController.text;
        request.fields['gender'] = _genderController.text;
        request.fields['addressDoorno'] = _addressDoorController.text;
        request.fields['addressStreet'] = _addressStreetController.text;
        request.fields['addressCity'] = _addressCityController.text;
        request.fields['addressState'] = _addressStateController.text;
        request.fields['addressPincode'] = _addressPincodeController.text;
        request.fields['usertype'] = 'Business'; // Default usertype
        request.fields['password'] = _passwordController.text;

        // Adding the profile image (optional)
        if (_profileImage != null) {
          request.files.add(
            await http.MultipartFile.fromPath('image', _profileImage!.path),
          );
        }

        // Sending the request
        var response = await request.send();

        if (response.statusCode == 201) {
          // Registration successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful!')),
          );
        } else {
          // Handle error response
          var responseBody = await response.stream.bytesToString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $responseBody')),
          );
        }
      } catch (e) {
        // Handle exception
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Business')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dobController,
                  decoration:
                      InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return 'Please enter a valid date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || !RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Mobile number must be 10 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _whatsappController,
                  decoration: InputDecoration(labelText: 'WhatsApp Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || !RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'WhatsApp number must be 10 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your gender';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressDoorController,
                  decoration: InputDecoration(labelText: 'Door Number'),
                ),
                TextFormField(
                  controller: _addressStreetController,
                  decoration: InputDecoration(labelText: 'Street'),
                ),
                TextFormField(
                  controller: _addressCityController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextFormField(
                  controller: _addressStateController,
                  decoration: InputDecoration(labelText: 'State'),
                ),
                TextFormField(
                  controller: _addressPincodeController,
                  decoration: InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value)) {
                      return 'Pincode must be 6 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Profile Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
