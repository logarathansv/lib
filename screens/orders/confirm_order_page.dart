import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/order_model/order_model.dart';
import 'package:sklyit_business/screens/orders/orders_list.dart';
import '../../models/customer_model/customer_class.dart';
import '../../models/product_model/product_model.dart';
import '../../models/service_model/service_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/order_provider.dart';
import '../customers/get_customer_details.dart';

class ConfirmOrderPage extends ConsumerStatefulWidget {
  final List<Service> selectedServices;
  final List<Product> selectedProducts;
  final DateTime selectedDate;
  final List<Customer> existingCustomers;

  const ConfirmOrderPage({
    super.key,
    required this.selectedServices,
    required this.selectedProducts,
    required this.selectedDate,
    required this.existingCustomers,
  });

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends ConsumerState<ConfirmOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _amountController = TextEditingController();
  Customer? _selectedCustomer;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Existing Customer Dropdown
              DropdownButtonFormField<Customer>(
                value: _selectedCustomer,
                decoration: const InputDecoration(
                  labelText: 'Select Existing Customer',
                  border: OutlineInputBorder(),
                ),
                items: widget.existingCustomers.map((Customer customer) {
                  return DropdownMenuItem<Customer>(
                    value: customer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(customer.email),
                        Text(customer.phoneNumber),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Customer? value) {
                  setState(() {
                    _selectedCustomer = value;
                    if (value != null) {
                      _customerNameController.text = value.custId.toString();
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              // Or Add New Customer
              const Text(
                'Or Add New Customer:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 8),
              // TextFormField(
              //   controller: _customerNameController,
              //   decoration: const InputDecoration(
              //     labelText: 'Customer Name',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a customer name';
              //     }
              //     return null;
              //   },
              //   enabled: false,
              // ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewCustomerPage(),
                    ),
                  );
                },
                child: const Text('Add New Customer'),
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Display Selected Services
              const Text(
                'Selected Services:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.selectedServices.map((service) {
                  return Text('- ${service.name}');
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Display Selected Products
              const Text(
                'Selected Products:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.selectedProducts.map((product) {
                  return Text(
                      '- ${product.name} (Quantity: ${product.quantity})');
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Display Selected Date
              const Text(
                'Selected Date:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.selectedDate.toLocal().toString().split(' ')[0]),
              const SizedBox(height: 16),

              // Confirm Order Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2f4757),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendOrder(CreateOrder order) async {
    try {
      ref.watch(orderServiceProvider).when(
        data: (orderService) async {
          await orderService.addOrder(order);
        },
        error: (error, stackTrace) {
          print('Error sending order: $error');
        },
        loading: () {
          print('Sending order...');
        },
      );
    } catch (e) {
      print('Error sending order: $e');
    }
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new order
      final newOrder = CreateOrder(
        services: widget.selectedServices.map((e) => {'sname':e.name,'cost': e.price}).toList(),
        products: widget.selectedProducts
            .map((e) => {'pname': e.name, 'quantity': e.quantity,'cost': e.price,'units': e.units})
            .toList(),
        customerId: _customerNameController.text,
        // orderDate: widget.selectedDate,
      );
      try {
        // Send the order to the server
        _sendOrder(newOrder);
      } catch (e) {
        print('Error sending order: $e');
      }
      // Return the new order to the previous page
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrdersPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }
}
