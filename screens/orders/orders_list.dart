import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/order_model/services_class.dart';
import 'package:sklyit_business/screens/orders/add_orders_page.dart';
import '../../models/customer_model/customer_class.dart';
import '../../models/order_model/order_class.dart';
import '../../models/product_model/product_class.dart'; // Import the Product class
import 'order_details.dart';

class AddOrdersPage extends StatefulWidget {
  final bool autoTriggerAddOrder;

  const AddOrdersPage({super.key, this.autoTriggerAddOrder = false});

  @override
  State<AddOrdersPage> createState() => _AddOrdersPageState();
}

class _AddOrdersPageState extends State<AddOrdersPage> {
  // Sample orders data
  final List<Order> orders = [
    Order(
      services: ['Plumbing', 'Electrical', 'Tailoring', 'Cleaning'],
      products: [
        {'name': 'Product A', 'quantity': 2},
        {'name': 'Product B', 'quantity': 1},
      ],
      customerName: 'John Doe',
      amount: 3000,
      date_time: DateTime(2023, 7, 16, 11, 30),
    ),
    Order(
      services: ['Electrical'],
      products: [
        {'name': 'Product C', 'quantity': 3},
      ],
      customerName: 'Jane Smith',
      amount: 1500,
      date_time: DateTime(2023, 7, 15, 14, 45),
    ),
    Order(
      services: ['Cleaning'],
      products: [],
      customerName: 'Emily Johnson',
      amount: 800,
      date_time: DateTime(2023, 7, 14, 9, 15),
    ),
  ];

  final _searchController = TextEditingController();
  final List<Customer> _customers = [];
  final List<Service> _services = [
    Service(name: 'Service A'),
    Service(name: 'Service B'),
    Service(name: 'Service C'),
  ];
  final List<Product> _products = [
    Product(name: 'Product A', price: 29.99),
    Product(name: 'Product B', price: 49.99),
    Product(name: 'Product C', price: 99.99),
  ];
  List<Order> _searchResults = [];
  String _filterType = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    if (widget.autoTriggerAddOrder) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToAddOrderPage();
      });
    }
  }

  void _navigateToAddOrderPage() async {
    final newOrder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrderPage(
          services: _services,
          products: _products,
          existingCustomers: _customers,
        ),
      ),
    );

    if (newOrder != null) {
      setState(() {
        orders.add(newOrder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 16),

            // Filter Tags
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterTag('All'),
                  _buildFilterTag('Recent'),
                  _buildFilterTag('Old'),
                  _buildFilterTag('Amount: Low to High'),
                  _buildFilterTag('Amount: High to Low'),
                  _buildFilterTag('Date: Oldest First'),
                  _buildFilterTag('Date: Newest First'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Add Order Button
            ElevatedButton.icon(
              onPressed: () async {
                // Navigate to the AddOrderPage
                final newOrder = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrderPage(
                      services: _services,
                      products: _products, // Pass the products list
                      existingCustomers: _customers,
                    ),
                  ),
                );

                // If a new order is returned, add it to the list
                if (newOrder != null) {
                  setState(() {
                    orders.add(newOrder);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2f4757),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Order',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // Orders List
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.isEmpty
                    ? _getFilteredOrders().length
                    : _searchResults.length,
                itemBuilder: (context, index) {
                  final order = _searchResults.isEmpty
                      ? _getFilteredOrders()[index]
                      : _searchResults[index];
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  OrderDetailsPage(order: order),
                          transitionDuration: const Duration(milliseconds: 200),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: const Offset(0, 0),
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      )
                    },
                    child: _buildOrderCard(order, context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Search... ",
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        onChanged: (text) => {_searchOrders()},
      ),
    );
  }

  // Build a filter tag
  Widget _buildFilterTag(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              _filterType == label ? const Color(0xfff4c345) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _filterType == label ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Filter orders based on the selected filter type
  List<Order> _getFilteredOrders() {
    switch (_filterType) {
      case 'Recent':
        return orders
            .where((order) => order.date_time
                .isAfter(DateTime.now().subtract(Duration(days: 7))))
            .toList();
      case 'Old':
        return orders
            .where((order) => order.date_time
                .isBefore(DateTime.now().subtract(Duration(days: 7))))
            .toList();
      case 'Amount: Low to High':
        return List.from(orders)..sort((a, b) => a.amount.compareTo(b.amount));
      case 'Amount: High to Low':
        return List.from(orders)..sort((a, b) => b.amount.compareTo(a.amount));
      case 'Date: Oldest First':
        return List.from(orders)
          ..sort((a, b) => a.date_time.compareTo(b.date_time));
      case 'Date: Newest First':
        return List.from(orders)
          ..sort((a, b) => b.date_time.compareTo(a.date_time));
      default:
        return orders;
    }
  }

  // Search orders
  void _searchOrders() {
    setState(() {
      _searchResults = _getFilteredOrders()
          .where((order) =>
              order.customerName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              order.amount.toString().contains(_searchController.text) ||
              order.date_time
                  .toString()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  // Order Card
  Widget _buildOrderCard(Order order, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Order Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order.services.first,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2f4757),
                      ),
                    ),
                    if (order.services.length > 1)
                      Text(
                        ' and ${order.services.length - 1} more',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2f4757),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order.customerName,
                  style: const TextStyle(color: Color(0xFF028F83)),
                ),
                if (order.products.isNotEmpty)
                  Text(
                    'Products: ${order.products.length}',
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
            // Action Icons
            Row(
              children: [
                IconButton(
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRightDouble,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            OrderDetailsPage(order: order),
                        transitionDuration: const Duration(milliseconds: 200),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: const Offset(0, 0),
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
