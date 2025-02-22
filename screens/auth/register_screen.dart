import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/auth/register_business.dart';

import '../../api/endpoints.dart';

class RegisterPage extends StatefulWidget {
  // final VoidCallback onLogout;
  //
  const RegisterPage({super.key});
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

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
  final _cpasswordController = TextEditingController();
  String? filePath;
  String? image;

  void _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.image
    );
    setState(() {
      (result == null || result.files.isEmpty) ? image = null : image = 'Choosen Image';
    });

    if (result != null && result.files.isNotEmpty) {
      filePath = result.files.first.path;
    }
  }

  Future<void> registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Input validation
        final password = _passwordController.text;
        final name = _nameController.text;
        final email = _emailController.text;

        // Check password strength
        final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.{10,20}$)');
        if (!passwordRegex.hasMatch(password)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Password must be 10-20 characters long, contain at least 1 uppercase letter and 1 special character.',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        // Sanitize inputs to prevent XSS attacks
        final sanitizedInputs = {
          'name': name.replaceAll(RegExp(r'[<>"]'), ''), // Strip harmful characters
          'gmail': email.replaceAll(RegExp(r'[<>"]'), ''),
          'dob': _dobController.text,
          'mobileno': _mobileController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'wtappNo': _whatsappController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'gender': _genderController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'addressDoorno': _addressDoorController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'addressStreet': _addressStreetController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'addressCity': _addressCityController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'addressState': _addressStateController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'addressPincode': _addressPincodeController.text.replaceAll(RegExp(r'[<>"]'), ''),
          'usertype': 'Business',
          'password': password,
          if(filePath != null) 'image': filePath
        };

        // Print sanitized payload for debugging
        print(sanitizedInputs);

        var uri = Uri.parse('${Endpoints.BASEURL}${Endpoints.register}');

        // Send POST request
        var response = http.MultipartRequest('POST', uri);
        sanitizedInputs.forEach((key, value) {
          response.fields[key] = value!;
        });

        // Add file if provided
        if (filePath != null) {
          response.files.add(await http.MultipartFile.fromPath(
            'image', // Field name in the backend
            filePath!,
          ));
        }

        // Add headers
        response.headers.addAll({
          'Content-Type': 'multipart/form-data',
        });

        // Send request
        var streamedResponse = await response.send();
        var res = await http.Response.fromStream(streamedResponse);
        Map<String, dynamic> responseData = jsonDecode(res.body);

        if (res.statusCode == 201) {
          print('User Registration successful!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration in progress...'),
              backgroundColor: Colors.teal.shade700,
            ),
          );
          if (responseData.containsKey('userId')) {
            await storage.write(key: 'userId', value: responseData['userId'].toString());
            print('User ID stored successfully!');
          } else {
            print('Error: userId not found in response.');
          }
        } else {
          String errorMessage = responseData['message'] ?? 'An error occurred';
          print(errorMessage); // Debugging
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $errorMessage'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: ()  {
            Navigator.of(context).pop();
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: Text(
          'Register',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(

        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _dobController,
                            readOnly: true, // Prevent manual editing
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.amber),
                              filled: true,
                              fillColor: Colors.teal.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: Colors.teal, // Header color
                                      hintColor: Colors.amber, // Accent color
                                      colorScheme: ColorScheme.light(primary: Colors.teal),
                                      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                setState(() {
                                  _dobController.text = formattedDate;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                                return 'Please enter a valid date';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 10),
                          TextFormField(
                            controller: _mobileController,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Mobile number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _whatsappController,
                            decoration: InputDecoration(
                              labelText: 'WhatsApp Number',
                              prefixIcon: Icon(Icons.phone_android),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'WhatsApp number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _genderController,
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              prefixIcon: Icon(Icons.people),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your gender';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _addressDoorController,
                            decoration: InputDecoration(
                              labelText: 'Door Number',
                              prefixIcon: Icon(Icons.home),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your door number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _addressStreetController,
                            decoration: InputDecoration(
                              labelText: 'Street',
                              prefixIcon: Icon(Icons.streetview),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your street';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _addressCityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              prefixIcon: Icon(Icons.location_city),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _addressStateController,
                            decoration: InputDecoration(
                              labelText: 'State',
                              prefixIcon: Icon(Icons.map),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your state';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _addressPincodeController,
                            decoration: InputDecoration(
                              labelText: 'Pincode',
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(r'^\d{6}$').hasMatch(value)) {
                                return 'Pincode must be 6 digits';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _cpasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please re-enter password';
                              }
                              else if(value != _passwordController.text){
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text('Upload Profile Image',
                              style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(width: 8),
                        (image != null && image!.isNotEmpty) ? Text(image!, style: TextStyle(color: Colors.redAccent,fontSize: 16)) : Text(''),
                      ]
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await registerUser(context);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
                            context) => RegistrationPage(), ), (route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.amber, backgroundColor: Colors.grey.shade50,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.amber,
                          width: 2.0,)
                    ),
                    child: Text('Next Page >>', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}