import 'package:flutter/material.dart';
import 'dart:async'; 

void main() {
  runApp(
    MaterialApp(
      home: NotificationsPage(),
    ));
}


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
  final int quantity;
  final double price;
  bool checked;

  Product({
    required this.name,
    this.quantity = 1,
    required this.price,
    this.checked = false,
  });
}

class PopupPage extends StatefulWidget {
  PopupPage({super.key});

  @override
  State<PopupPage> createState() => _PopupPageState();
}

class _PopupPageState extends State<PopupPage> {
  final List<Product> _products = [
    Product(name: 'Product 1',quantity: 1, price: 100.0),
    Product(name: 'Product 2', quantity: 1, price: 200.0),
    Product(name: 'Product 3', quantity: 3, price: 150.0),
    Product(name: 'Product 4', quantity: 4, price: 400.0),
  ];

  bool _showAll = false;
  
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
  
    // Function to calculate total payment based on selected products
double get _totalPayment{
  return _products.fold(0,(sum, product) => sum + (product.checked ? product.price * product.quantity : 0));
}

@override
Widget build(BuildContext context) {
  List<Product> visibleProducts = _showAll ? _products : _products.take(3).toList();
  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: null,
    body: Column(
      children: [
        // Half-circle timer below message area
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
             Positioned(
              top: -30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_bag, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Order',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
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
        
        // Order section with icon and total
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
            ),
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              child: Text(
                'Total Payment : ₹${_totalPayment.toStringAsFixed(2)}', // Replace this with your dynamic value
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Product Name", style : TextStyle(fontWeight: FontWeight.bold)),
              Text("Quantity", style : TextStyle(fontWeight: FontWeight.bold)),
              Text("Price", style : TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        
        // Product list
        Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: visibleProducts.length + (_showAll || _products.length <= 3 ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index < visibleProducts.length) {
                    final product = visibleProducts[index];
                    return CheckboxListTile(
                      value: product.checked,
                      onChanged: (val) {
                        setState(() {
                          product.checked = val ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(product.name),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(child: Text('${product.quantity}')),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('₹${product.price.toStringAsFixed(2)}'),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showAll = true;
                          });
                        },
                        child: const Text("View More"),
                      ),
                    );
                  }
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
