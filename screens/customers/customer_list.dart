import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/customers/customer_details.dart';
import 'package:sklyit_business/screens/customers/get_customer_details.dart';
import '../../models/customer_model/customer_class.dart';
import '../../widgets/customer_cards/customer_view.dart';

class AddCustomerPage extends StatefulWidget {
  final bool autoTriggerAddCustomer; // Add this flag

  const AddCustomerPage(
      {super.key, this.autoTriggerAddCustomer = false}); // Default to false

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final List<Customer> _customers = [
    Customer(
      name: 'John Doe',
      address: '123 Main St, City, Country',
      email: 'johndoe@example.com',
      phoneNumber: '+1 123 456 7890',
      labelColor: Colors.blue,
    ),
    Customer(
      name: 'Jane Smith',
      address: '456 Elm St, Town, Country',
      email: 'janesmith@example.com',
      phoneNumber: '+1 987 654 3210',
      labelColor: Colors.green,
    ),
    Customer(
      name: 'Alice Johnson',
      address: '789 Oak St, Village, Country',
      email: 'alice@example.com',
      phoneNumber: '+1 555 555 5555',
      labelColor: Colors.purple,
    ),
  ];

  final _searchController = TextEditingController();
  List<Customer> _searchResults = [];
  String _filterType = 'All'; // Default filter

  @override
  void initState() {
    super.initState();

    // Automatically trigger the "Add Customer" button if the flag is true
    if (widget.autoTriggerAddCustomer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerAddCustomer();
      });
    }
  }

  // Method to simulate the "Add Customer" button press
  void _triggerAddCustomer() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddNewCustomerPage(),
        transitionDuration: const Duration(milliseconds: 100),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'Customers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.all(5),
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                        onChanged: (text) => _searchCustomers(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Filter Tags
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterTag('All'),
                          _buildFilterTag('Recent'),
                          _buildFilterTag('Old'),
                          _buildFilterTag('Frequent'),
                          _buildFilterTag('Most Valued'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.isEmpty
                      ? _getFilteredCustomers().length
                      : _searchResults.length,
                  itemBuilder: (context, index) {
                    final customer = _searchResults.isEmpty
                        ? _getFilteredCustomers()[index]
                        : _searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomerDetailsPage(customer: customer),
                          ),
                        );
                      },
                      child: CustomerCard(
                        customer: customer,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Add Customer Button
          Positioned(
            bottom: 25,
            right: 20,
            child: ElevatedButton(
              onPressed: _triggerAddCustomer, // Use the method here
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff4c345),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                minimumSize: const Size(40, 40),
              ),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
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

  // Filter customers based on the selected filter type
  List<Customer> _getFilteredCustomers() {
    // Mock filtering logic (replace with actual logic when backend is ready)
    switch (_filterType) {
      case 'Recent':
        return _customers
            .where(
                (customer) => customer.name.contains('John')) // Example filter
            .toList();
      case 'Old':
        return _customers
            .where(
                (customer) => customer.name.contains('Jane')) // Example filter
            .toList();
      case 'Frequent':
        return _customers
            .where(
                (customer) => customer.name.contains('Alice')) // Example filter
            .toList();
      case 'Most Valued':
        return _customers
            .where((customer) =>
                customer.email.contains('example')) // Example filter
            .toList();
      default:
        return _customers;
    }
  }

  // Search customers
  void _searchCustomers() {
    setState(() {
      _searchResults = _getFilteredCustomers()
          .where((customer) =>
              customer.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              customer.address
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              customer.phoneNumber
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }
}
