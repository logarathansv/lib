import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/customer_model/customer_class.dart';
import '../../models/product_model/product_model.dart'; // Import the Product class
import '../../models/service_model/service_model.dart';
import './confirm_order_page.dart';

class AddOrderPage extends StatefulWidget {
  final List<Service> services;
  final List<Product> products;
  final List<Customer> existingCustomers;

  const AddOrderPage({
    super.key,
    required this.services,
    required this.products,
    required this.existingCustomers,
  });

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Service> _selectedServices = [];
  final List<Product> _selectedProducts = [];
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Services and Products
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfff4c345),
          title: const Text(
            'Add New Order',
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Services'),
              Tab(text: 'Products'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Date Picker
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    }
                  },
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${_selectedDate!.toLocal()}'
                            .split(' ')[0],
                  ),
                ),
                const SizedBox(height: 16),

                // Tabs for Services and Products
                const SizedBox(height: 16),
                const Text(
                  'Select Items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 300, // Adjust height as needed
                  child: TabBarView(
                    children: [
                      // Services Tab
                      ListView(
                        children: widget.services.map((service) {
                          return CheckboxListTile(
                            title: Text(service.name),
                            value: _selectedServices.contains(service),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedServices.add(service);
                                } else {
                                  _selectedServices.remove(service);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      // Products Tab
                      ListView(
                        children: widget.products.map((product) {
                          return Column(
                            children: [
                              CheckboxListTile(
                                title: Text(product.name),
                                value: _selectedProducts.contains(product),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedProducts.add(product);
                                    } else {
                                      _selectedProducts.remove(product);
                                    }
                                  });
                                },
                              ),
                              if (_selectedProducts.contains(product))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: TextFormField(
                                    initialValue: '1',
                                    decoration: const InputDecoration(
                                      labelText: 'Quantity',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,

                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Submit Button
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2f4757),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // Navigate to the ConfirmOrderPage
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmOrderPage(
            selectedServices: _selectedServices,
            selectedProducts: _selectedProducts,
            selectedDate: _selectedDate!,
            existingCustomers: widget.existingCustomers,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select a date')),
      );
    }
  }
}
