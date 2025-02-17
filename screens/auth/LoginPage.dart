import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sklyit_business/screens/auth/register_screen.dart';

import '../../api/auth_api/login_api.dart';
import '../../main.dart';

class LoginPage extends ConsumerStatefulWidget {
  final GlobalKey<RegisterPageState> registerPageKey = GlobalKey<RegisterPageState>();
  LoginPage({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  bool _isLoading = false; // 🔹 Added loading state

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // 🔹 Start loading
    });

    final loginService = ref.read(loginApiProvider);
    final res = await loginService.login(
      usernameController.text,
      passwordController.text,
    );

    print('Login response: $res'); // Debugging

    if (res == 'Login successful') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SklyitApp()),
              (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    setState(() {
      _isLoading = false; // 🔹 Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, size: 80.0, color: Colors.amber),
                  SizedBox(height: 10.0),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Welcome back,\nplease login to your account',
                    style: TextStyle(fontSize: 25.0, color: Colors.teal.shade700),
                  ),
                ],
              ),
              Column(
                children: [
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.amber),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.amber),
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
                        style: TextStyle(fontSize: 18.0, color: Colors.teal),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                onPressed: _isLoading ? null : _login, // 🔹 Disable when loading
                child: _isLoading
                    ? CircularProgressIndicator(
                  color: Colors.white, // 🔹 Show loader while logging in
                )
                    : Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage(key: widget.registerPageKey,)),
                      );
                    },
                    child: Text(
                      ' Sign Up',
                      style: TextStyle(fontSize: 18.0, color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
