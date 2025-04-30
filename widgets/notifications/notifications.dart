import 'package:flutter/material.dart';
import 'dart:async';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start position (off-screen above)
      end: const Offset(0, 0), // End position (on-screen)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showPopupPage(BuildContext context) {
  showFilterPopup(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(onPressed: ()=> _showPopupPage(context),
                   icon: const Icon(Icons.tune))
                ],
              ),
              const Divider(
                thickness: 3,
                color: Color(0xfff4c345),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: ListView(
                children: [
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  // Add more notifications here as needed
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String username,
    required String message,
    required String time,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2f4757),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
              onPressed: () {
                // Handle delete action
              },
            ),
          ],
        ),
      ),
    );
  }
}


// 1. First, create a Product model class (can be in same file or separate)

class Product {
  final String name;
  bool checked;

  Product({
    required this.name,
    this.checked = false,
  });
}

class PopupPage extends StatefulWidget {
  PopupPage({super.key});

  @override
  State<PopupPage> createState() => _PopupPageState();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}

class _PopupPageState extends State<PopupPage> {
  final List<Product> _products = [
    Product(name: 'Product 1'),
    Product(name: 'Product 2'),
    Product(name: 'Product 3'),
  ];
  
  int _secondsRemaining = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
  const oneSec = Duration(seconds: 1);
  _timer = Timer.periodic(oneSec, (Timer timer) {
    if (_secondsRemaining == 0) {
      timer.cancel();
      Navigator.of(context).pop(); // Close the popup when timer reaches 0
    } else {
      setState(() {
        _secondsRemaining--;
      });
    }
  });
}

@override
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: null,
    body: Column(
      children: [
        // Status message area at the top
        /*
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          alignment: Alignment.center,
          child: const SizedBox.shrink(), // Placeholder for messages
        ),
        */
        // Half-circle timer below message area
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  '$_secondsRemaining',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        Container(
          color: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          child: const Text(
            'Order',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        
        // Product list
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_products[index].name),
                  value: _products[index].checked,
                  onChanged: (bool? value) {
                    setState(() {
                      _products[index].checked = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                );
              },
            ),
          ),
        ),
        
        // Modified Accept Order button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                bool atLeastOneSelected = _products.any((product) => product.checked);
                if (atLeastOneSelected) {
                  // Show message at top
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Order Accepted!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  
                  // Close popup after delay
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one product'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text(
                'Accept Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}

// Function to show the modal popup
void showFilterPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: PopupPage(),
      );
    },
  );
}

