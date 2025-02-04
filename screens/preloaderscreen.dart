import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sklyit_business/screens/auth/LoginPage.dart';
import 'package:sklyit_business/providers/auth_provider.dart';
import 'package:sklyit_business/main.dart';
import 'package:sklyit_business/screens/business_view/business_perspective.dart';

class PreloaderScreen extends ConsumerStatefulWidget {
  const PreloaderScreen({super.key});

  @override
  _PreloaderScreenState createState() => _PreloaderScreenState();
}

class _PreloaderScreenState extends ConsumerState<PreloaderScreen> {
  bool _isLoading = true;
  bool _isInitialLoad = true; // Flag to track initial load

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Simulate a delay for the preloader (e.g., 3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to the appropriate screen based on the token
      if (token != null && token.isNotEmpty) {
        ref.read(authTokenProvider.notifier).state = token;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show the preloader during the initial load
    if (_isInitialLoad) {
      return Scaffold(
        body: Center(
          child: _isLoading
              ? Image.asset(
                  'assets/preloadingskly.gif') // Display the preloader GIF
              : const CircularProgressIndicator(), // Fallback if GIF fails to load
        ),
      );
    } else {
      // If it's not the initial load, navigate directly to the home screen
      return const PersonalCareBusinessPage();
    }
  }
}
