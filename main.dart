import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sklyit_business/LoginPage.dart';
import 'package:sklyit_business/auth/auth_provider.dart';
import 'screens/business_perspective.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/ledger/add_contact.dart';
import 'screens/tools/tools_screen.dart';
import 'screens/settings/settings_page.dart';
import 'widgets/notifications/notifications.dart';
import 'data/business_provider.dart';
import 'preloaderscreen.dart'; // Import the PreloaderScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token'); // Retrieve the token

  bool isTokenValid = false;
  if (token != null && token.isNotEmpty) {
    try {
      // Check if the token is a valid JWT format
      if (token.split('.').length == 3) {
        // Skip expiration check since the token doesn't have an `exp` field
        isTokenValid = true;
      } else {
        print('Invalid JWT token format');
        await prefs.remove('auth_token'); // Clear the invalid token
      }
    } catch (e) {
      print('Error decoding token: $e');
      await prefs.remove('auth_token'); // Clear the invalid token
    }
  }

  runApp(
    ProviderScope(
      child: SklyitApp(token: isTokenValid ? token : null), // Pass valid token
    ),
  );
}

class SklyitApp extends StatelessWidget {
  final String? token;

  const SklyitApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sklyit - Business Page',
      theme: ThemeData(
        primaryColor: Colors.amberAccent,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
          displayLarge: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      home: const PersonalCareBusinessPage(), // Show the PreloaderScreen first
      routes: {
        '/addContactPage': (context) => const AddContactPage(),
        '/home': (context) => const PersonalCareBusinessPage(),
        '/login': (context) => LoginPage(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const PersonalCareBusinessPage(),
        );
      },
    );
  }
}

class PersonalCareBusinessPage extends ConsumerStatefulWidget {
  const PersonalCareBusinessPage({super.key});

  @override
  _PersonalCareBusinessPageState createState() =>
      _PersonalCareBusinessPageState();
}

class _PersonalCareBusinessPageState
    extends ConsumerState<PersonalCareBusinessPage> {
  int _currentIndex = 2;
  Timer? _tokenExpiryTimer;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ShowToolsPage(),
      NotificationsPage(),
      Text('Home'),
      // BusinessPerspective(),
      ChatScreen(),
      const SettingsPage(),
    ];
    _startTokenExpiryTimer();
  }

  @override
  void dispose() {
    _tokenExpiryTimer?.cancel();
    super.dispose();
  }

  void _startTokenExpiryTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      try {
        // Skip expiration check since the token doesn't have an `exp` field
        var isTokenValid = true;
      } catch (e) {
        print('Error decoding token: $e');
        await prefs.remove('auth_token');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: const Color(0xFF2f4757),
        buttonBackgroundColor: const Color(0xfff4c345),
        items: const [
          CurvedNavigationBarItem(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedWrench01,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
            ),
          ),
          CurvedNavigationBarItem(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedBriefcase04,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          CurvedNavigationBarItem(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedComment01,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          CurvedNavigationBarItem(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
              color: Colors.black,
              size: 24.0,
            ),
          ),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        color: Colors.white,
      ),
    );
  }
}
