import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sklyit_business/auth/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  static String id = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String email = '';
  String password = '';

  bool _wrongEmail = false;
  bool _wrongPassword = false;

  String emailText = 'Email doesn\'t match';
  String passwordText = 'Password doesn\'t match';

  bool _isLoading = false;

  Future<void> _login() async {
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _wrongEmail = true;
      });
      return;
    }

    if (password.isEmpty || password.length < 6) {
      setState(() {
        _wrongPassword = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/bs/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': email,
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.body;

        print('Token received: $token');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        ref.read(authTokenProvider.notifier).state = token;

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _wrongEmail = true;
          _wrongPassword = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Invalid email or password')),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/images/background.png'),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 50.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Text(
                      'please login',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Text(
                      'to your account',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          _wrongEmail = false;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        errorText: _wrongEmail ? emailText : null,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                          _wrongPassword = false;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        errorText: _wrongPassword ? passwordText : null,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          print('Forgot Password tapped');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff447def),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
