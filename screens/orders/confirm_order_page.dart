import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/order_model/order_model.dart';
import 'package:sklyit_business/screens/orders/orders_list.dart';

import '../../models/customer_model/customer_class.dart';
import '../../models/product_model/product_model.dart';
import '../../models/service_model/service_model.dart';
import '../../providers/order_provider.dart';
import '../customers/get_customer_details.dart';

class ConfirmOrderPage extends ConsumerStatefulWidget {
  final List<Service> selectedServices;
  final List<Product> selectedProducts;
  final DateTime selectedDate;
  final List<Customer> existingCustomers;
  final Map<Service, int> serviceQuantities;
  final Map<Product, int> productQuantities;
  final bool isQuickOrder;
  final Customer quickOrderCustomer = Customer(
    custId: '15dda9af-6527-02ba-ec06-f5e85dff7156',
    name: 'Quick Order',
    email: 'quick@order.com',
    phoneNumber: '0000000000',
    address: 'Quick Order Address',
    createdAt: DateTime.now().toIso8601String(),
  );

  ConfirmOrderPage({
    super.key,
    required this.selectedServices,
    required this.serviceQuantities,
    required this.productQuantities,
    required this.selectedProducts,
    required this.selectedDate,
    required this.existingCustomers,
    this.isQuickOrder = false,
  });

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends ConsumerState<ConfirmOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  Customer? _selectedCustomer;
  bool _isQuickOrder = false;

  @override
  void initState() {
    super.initState();
    _isQuickOrder = widget.isQuickOrder;
    if (widget.isQuickOrder && widget.quickOrderCustomer != null) {
      _selectedCustomer = widget.quickOrderCustomer;
      _customerNameController.text =
          widget.quickOrderCustomer!.custId.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        title: const Text(
          'Confirm Order',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Order Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2f4757),
                    ),
                  ),
                  Switch(
                    value: _isQuickOrder,
                    onChanged: (value) {
                      setState(() {
                        _isQuickOrder = value;
                        if (!value) {
                          _selectedCustomer = null;
                          _customerNameController.clear();
                        } else if (widget.quickOrderCustomer != null) {
                          _selectedCustomer = widget.quickOrderCustomer;
                          _customerNameController.text =
                              widget.quickOrderCustomer!.custId.toString();
                        }
                      });
                    },
                    activeColor: const Color(0xFF2f4757),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Customer Selection Section
              if (!_isQuickOrder) ...[
                const Text(
                  'Customer Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2f4757),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final selected = await Navigator.push<Customer>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerSelectionPage(
                          existingCustomers: widget.existingCustomers,
                        ),
                      ),
                    );
                    if (selected != null) {
                      setState(() {
                        _selectedCustomer = selected;
                        _customerNameController.text =
                            selected.custId.toString();
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: _selectedCustomer == null
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Customer',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedCustomer!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedCustomer!.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedCustomer!.phoneNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Services Section
              const Text(
                'Selected Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2f4757),
                ),
              ),
              const SizedBox(height: 12),
              ...widget.selectedServices.map((service) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Quantity: ${widget.serviceQuantities[service]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${service.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2f4757),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),

              // Products Section
              if (widget.selectedProducts.isNotEmpty)
                const Text(
                  'Selected Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2f4757),
                  ),
                ),
              const SizedBox(height: 12),
              ...widget.selectedProducts.map((product) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Quantity: ${widget.productQuantities[product]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${product.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2f4757),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                final serviceTotal = widget.selectedServices.fold<double>(
                  0.0,
                  (sum, service) =>
                      sum +
                      (double.parse(service.price) *
                          widget.serviceQuantities[service]!),
                );
                final productTotal = widget.selectedProducts.fold<double>(
                  0.0,
                  (sum, product) =>
                      sum +
                      (double.parse(product.price) *
                          widget.productQuantities[product]!),
                );
                final subtotal = serviceTotal + productTotal;
                final tax = subtotal * 0.18;
                final totalAmount = subtotal + tax;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAmountRow('Subtotal', subtotal),
                    _buildAmountRow('GST (18%)', tax),
                    const SizedBox(height: 8),
                    _buildAmountRow('Total Amount', totalAmount, isTotal: true),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2f4757),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirm Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOrder(CreateOrder order) async {
    try {
      final orderService = ref.read(orderServiceProvider).value;

      if (orderService == null) {
        print('OrderService not available');
        return;
      }

      await orderService.addOrder(order);
      ref.invalidate(getOrdersProvider);
      print('Order Invalidated successfully');
    } catch (e) {
      print('Error sending order: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Create a new order
      final newOrder = CreateOrder(
        services: widget.selectedServices
            .map((e) => {
                  'sname': e.name,
                  'cost': e.price,
                  'quantity': widget.serviceQuantities[e]
                })
            .toList(),
        products: widget.selectedProducts
            .map((e) => {
                  'pname': e.name,
                  'quantity': widget.productQuantities[e],
                  'cost': e.price,
                  'units': e.units
                })
            .toList(),
        customerId: _customerNameController.text,
        orderDate: widget.selectedDate,
      );
      try {
        // Send the order to the server
        await _sendOrder(newOrder);
      } catch (e) {
        print('Error sending order: $e');
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AddOrdersPage()),
        (route) => false,
      );
    }
  }
}

Widget _buildAmountRow(String label, double amount, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: const Color(0xFF2f4757),
          ),
        ),
      ],
    ),
  );
}

class CustomerSelectionPage extends StatefulWidget {
  final List<Customer> existingCustomers;

  const CustomerSelectionPage({
    super.key,
    required this.existingCustomers,
  });

  @override
  State<CustomerSelectionPage> createState() => _CustomerSelectionPageState();
}

class _CustomerSelectionPageState extends State<CustomerSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Customer> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _filteredCustomers = widget.existingCustomers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        title: const Text(
          'Select Customer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewCustomerPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFF2f4757),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredCustomers = widget.existingCustomers
                      .where((customer) =>
                          customer.name
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          customer.email
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          customer.phoneNumber.contains(value))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context, customer);
                    },
                    title: Text(
                      customer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          customer.phoneNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
