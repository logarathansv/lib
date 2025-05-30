import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/models/product_model/product_model.dart';
import 'package:sklyit_business/providers/product_provider.dart';
import 'package:sklyit_business/utils/socket/order_socket_service.dart';
import 'package:sklyit_business/widgets/notifications/wait_for_customer.dart';

import '../../models/notification_model.dart';

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

class PopupPage extends ConsumerStatefulWidget {
  final String
      message; // Add this line to receive the message from the previous page
  final dynamic data;
  final Function(Map<String, dynamic>) onAccept;

  const PopupPage(
      {super.key,
      required this.message,
      required this.data,
      required this.onAccept});

  @override
  ConsumerState<PopupPage> createState() => _PopupPageState();
}

class _PopupPageState extends ConsumerState<PopupPage> {
  List<Product> availableProducts = [];
  List<FlashProductList> products = [];
  bool _showAll = false;
  int _secondsRemaining = 60;
  late Timer _timer;
  String busid = '';
  final OrderSocketService socket = OrderSocketService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _populateProducts(List<Product> fetchedProducts) {
    availableProducts = fetchedProducts;
    busid = fetchedProducts[0].busid!;
    print(availableProducts[0]);
    print(widget.data['products']);

    for (dynamic item in widget.data['products'].toList()) {
      print(item);
      final match = availableProducts.firstWhere((p) => p.id == item['pid']);

      // Parse quantity safely
      final quantity = (item['quantity'] is String)
          ? int.tryParse(item['quantity']) ?? 1
          : item['quantity'] ?? 1;

      final price = double.tryParse(match.price.toString()) ?? 0.0;
      final total = price * quantity;
      products.add(FlashProductList(
        name: match.name,
        units: match.units,
        bpid: match.bpid!,
        price: price.toString(),
        quantity: quantity,
        checked: false,
      ));

      print(products);
    }
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

  double get _totalPayment {
    return products.fold(
      0.0,
      (sum, product) {
        final price = double.tryParse(product.price) ?? 0.0;
        final quantity = int.tryParse(product.quantity.toString()) ?? 1;
        return sum + (product.checked ? price * quantity : 0.0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final getProductsAsync = ref.watch(getProductsProvider);
    return getProductsAsync.when(
      data: (fetchedProducts) {
        if (availableProducts.isEmpty) {
          _populateProducts(fetchedProducts);
        }
        return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bag image above timer
                      Image.asset(
                        'assets/images/bag.png',
                        height: 140,
                        width: 140,
                        fit: BoxFit.contain,
                      ),
                      // Half-circle timer below message area
                      Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_bag, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Incoming Order',
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
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.deepOrangeAccent
                                ],
                              ),
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
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Product Name",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Quantity",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Price",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      // Product list
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: products.length +
                                (_showAll || products.length <= 3 ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index < products.length) {
                                final product = products[index];
                                return CheckboxListTile(
                                  value: product.checked,
                                  onChanged: (val) {
                                    setState(() {
                                      product.checked = val ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(product.name),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Text('${product.quantity}')),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text('₹${product.price}'),
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

                      // Modified Accept Order and Decline buttons
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Order Declined'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Decline',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  bool allSelected = products
                                      .every((product) => product.checked);
                                  if (allSelected) {
                                    final List<Map<String, dynamic>>
                                        selectedProducts = products
                                            .where((product) => product.checked)
                                            .map((product) => {
                                                  'bpid': product.bpid,
                                                  'quantity': product.quantity,
                                                  'price': product.price,
                                                })
                                            .toList();
                                    final payload = {
                                      'orderId': widget.data['orderId'],
                                      'domain': widget.data['domain'],
                                      'username': widget.data['username'],
                                      'businessId': busid,
                                      'products': selectedProducts,
                                    };
                                    widget.onAccept(payload);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WaitingForCustomerScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please select all products'),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
