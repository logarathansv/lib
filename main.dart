import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sklyit_business/screens/auth/LoginPage.dart';
import 'package:sklyit_business/screens/business_view/customer_perspective.dart';
import 'package:sklyit_business/screens/chat/chat_dashboard.dart';
import 'package:sklyit_business/screens/flash/flash_main.dart';
import 'package:sklyit_business/utils/socket/order_socket_service.dart';
import 'package:sklyit_business/utils/socket/socket_service.dart';
import 'api/check_refresh.dart';
import 'screens/business_view/business_perspective.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/tools/tools_screen.dart';
import 'screens/settings/settings_page.dart';
import 'widgets/notifications/notifications.dart';
import 'widgets/preloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String uid = '';
final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid && (await _checkNotificationPermission())) {
    runApp(
      ProviderScope(
        child: SklyitApp(),
      ),
    );
  }
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
Future<bool> _checkNotificationPermission() async {
  if (Platform.isAndroid) {
    final PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      // Request permission
      final PermissionStatus newStatus = await Permission.notification.request();
      return newStatus.isGranted;
    }
    return status.isGranted;
  }
  return true; // Assume granted for other platforms
}

class SklyitApp extends StatefulWidget {
  const SklyitApp({super.key});

  @override
  State<SklyitApp> createState() => _SklyitAppState();
}

class _SklyitAppState extends State<SklyitApp> with WidgetsBindingObserver {
  late Future<bool> _initializationFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializationFuture = initialization();
    _checkInternetOnStart();
    _listenForInternetChanges();
  }

  Future<void> _checkInternetOnStart() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  void _listenForInternetChanges() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first == ConnectivityResult.none && !_isDialogOpen) {
        _showNoInternetDialog();
      } else if (results.isNotEmpty && results.first != ConnectivityResult.none && _isDialogOpen) {
        Navigator.pop(context);
        _isDialogOpen = false;
      }
    });
  }

  bool _isDialogOpen = false;

  void _showNoInternetDialog() {
    setState(() {
      _isDialogOpen = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Column(
            children: [
              Icon(Icons.wifi_off, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text("No Internet Connection", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ],
          ),
          content: Text("Please check your internet connection and try again.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => exit(0),
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent, padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
              child: Text("Exit", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> initialization() async {
    final prefs = await SharedPreferences.getInstance();
    final rtoken = await storage.read(key: 'rtoken');
    final isValidRefresh = (rtoken != null) ? await CheckRefreshValid().isRefreshValid() : false;
    final logged = prefs.getBool("is_logged") ?? false;

    if (logged && isValidRefresh) {
      uid = (await storage.read(key: 'userId'))!;
      SocketService().initialize(uid);
      OrderSocketService().initialize(uid);
      return true;
    }

    return false;
  }
  final OrderSocketService _orderSocketService = OrderSocketService();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _orderSocketService.navigatorKey,
      title: 'Sklyit - Business Page',
      theme: ThemeData(
        primaryColor: Colors.amberAccent,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0, color: Colors.grey[800], fontWeight: FontWeight.w500),
          displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SplashScreen(); // Replace with your splash/loading screen
          }
          return snapshot.data == true ? PersonalCareBusinessPage() : LoginPage();
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isDialogOpen) {
      _showNoInternetDialog();
    }
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
      CustomerPerspective(),
      FlashScreen(),
      ChatDashboard(uid: uid),
      SettingsPage(),
    ];
  }

  @override
  void dispose() {
    _tokenExpiryTimer?.cancel();
    super.dispose();
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
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedBriefcase04,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          CurvedNavigationBarItem(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedFlash,
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
