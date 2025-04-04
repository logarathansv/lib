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
  final Map<Service,int> serviceQuantities;
  final Map<Product,int> productQuantities;

  const ConfirmOrderPage({
    super.key,
    required this.selectedServices,
    required this.serviceQuantities,
    required this.productQuantities,
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
                    child: SizedBox(
                      width: 250,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                customer.email,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                customer.phoneNumber,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              // Or Add New Customer
              const Text(
                'Or Add New Customer:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

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

              // // Amount Field
              // TextFormField(
              //   controller: _amountController,
              //   decoration: const InputDecoration(
              //     labelText: 'Amount',
              //     border: OutlineInputBorder(),
              //   ),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter an amount';
              //     }
              //     if (double.tryParse(value) == null) {
              //       return 'Please enter a valid number';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 16),

              // Display Selected Services
              const Text(
                'Selected Services:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.selectedServices.map((service) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Amount: ₹${service.price}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quantity: ${widget.productQuantities[product]}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Amount: ₹${product.price}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
              // Total Amount
              const Text(
                'Total Amount:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${widget.selectedServices.fold<double>(
                  0.0,
                  (previousValue, element) => previousValue + (double.parse(element.price) * widget.serviceQuantities[element]!),
                ) +
                    widget.selectedProducts.fold<double>(
                  0.0,
                  (previousValue, element) => previousValue + (double.parse(element.price) * widget.productQuantities[element]!),
                )}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
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
      ref.invalidate(getOrdersProvider);
    } catch (e) {
      print('Error sending order: $e');
    }
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new order
      final newOrder = CreateOrder(
        services: widget.selectedServices.map((e) => {'sname':e.name,'cost': e.price,'quantity': widget.serviceQuantities[e]}).toList(),
        products: widget.selectedProducts
            .map((e) => {'pname': e.name, 'quantity': widget.productQuantities[e],'cost': e.price,'units': e.units})
            .toList(),
        customerId: _customerNameController.text,
        orderDate: widget.selectedDate,
      );
      try {
        // Send the order to the server
        _sendOrder(newOrder);
      } catch (e) {
        print('Error sending order: $e');
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AddOrdersPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }
}
