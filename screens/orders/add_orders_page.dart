import 'dart:math';

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
  final Map<Service, int> _serviceQuantities = {};
  Map<Product, int> _productQuantities = {};
  final List<Service> _selectedServices = [];
  int _selectedServiceQuantity=1;
  final List<Product> _selectedProducts = [];
  int _selectedProductQuantity=1;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Services
              const SizedBox(height: 16),
              const Text(
                'Select Services:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.services.map((service) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Text(service.name),
                        value: _selectedServices.contains(service),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedServices.add(service);
                              _serviceQuantities[service] = 1;
                            } else {
                              _selectedServices.remove(service);
                              _serviceQuantities.remove(service);
                            }
                          });
                        },
                      ),
                      if (_selectedServices.contains(service))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text('Quantity:'),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  onPressed: () {
                                    setState(() {
                                      if (_serviceQuantities[service]! > 1) {
                                        _serviceQuantities[service] = _serviceQuantities[service]! - 1;
                                      }
                                    });
                                  },
                                  color: Colors.grey,
                                  splashRadius: 15,
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(text: _serviceQuantities[service].toString()),
                                  onChanged: (value) {
                                    setState(() {
                                      final quantity = int.tryParse(value);
                                      if (quantity != null && quantity > 0) {
                                        _serviceQuantities[service] = quantity;
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  onPressed: () {
                                    setState(() {
                                      _serviceQuantities[service] = _serviceQuantities[service]! + 1;
                                    });
                                  },
                                  color: Colors.grey,
                                  splashRadius: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }).toList(),
              )
              ,

              // Products
              const SizedBox(height: 16),
              const Text(
                'Select Products:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                              _productQuantities[product] = 1;
                            } else {
                              _selectedProducts.remove(product);
                              _productQuantities.remove(product);
                            }
                          });
                        },
                      ),
                      if (_selectedProducts.contains(product))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text('Quantity:'),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  onPressed: () {
                                    setState(() {
                                      if (_productQuantities[product]! > 1) {
                                        _productQuantities[product] = _productQuantities[product]! - 1;
                                      }
                                    });
                                  },
                                  color: Colors.grey,
                                  splashRadius: 15,
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(text: _productQuantities[product].toString()),
                                  onChanged: (value) {
                                    setState(() {
                                      final quantity = int.tryParse(value);
                                      if (quantity != null && quantity > 0) {
                                        _productQuantities[product] = quantity;
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  onPressed: () {
                                    setState(() {
                                      _productQuantities[product] = _productQuantities[product]! + 1;
                                    });
                                  },
                                  color: Colors.grey,
                                  splashRadius: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
              // Date Picker
              const SizedBox(height: 16),
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
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // Navigate to the ConfirmOrderPage
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmOrderPage(
            serviceQuantities:_serviceQuantities,
            productQuantities:_productQuantities,
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
