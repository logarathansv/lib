// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEE034),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome Back!',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          constraints: BoxConstraints(maxWidth: 400), // Set a max width
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(0xFFFEE034),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            _formKey.currentState!.save();

                            // Simulate a delay for authentication
                            await Future.delayed(Duration(seconds: 2));

                            print('Email: $_email, Password: $_password');
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Sign In',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                ),
                SizedBox(height: 20),
                Text('or', style: TextStyle(color: Colors.black)),
                SizedBox(height: 20),
                Column(
                  children: [
                    // Google Sign-In button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        side: BorderSide(color: Colors.black),
                      ),
                      icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: () {
                        // TODO: Add Sign-In with Google functionality
                      },
                    ),
                    SizedBox(height: 10),
                    // FaceBook Sign-In button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        side: BorderSide(color: Colors.black),
                      ),
                      icon:
                          FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                      label: Text(
                        'Sign in with Facebook',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: () {
                        // TODO: Add Sign-In with Facebook functionality
                      },
                    ),
                    SizedBox(height: 10),
                    // Apple Sign-In button
                    OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          side: BorderSide(color: Colors.black),
                        ),
                        icon:
                            FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                        label: Text(
                          'Sign in with Apple',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        onPressed: () {
                          // TODO: Add Sign-In with Apple functionality
                        })
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to Sign Up page
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
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
