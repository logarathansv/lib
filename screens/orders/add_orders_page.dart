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
  final bool isQuickOrder;
  final Customer? quickOrderCustomer;

  const AddOrderPage({
    super.key,
    required this.services,
    required this.products,
    required this.existingCustomers,
    this.isQuickOrder = false,
    this.quickOrderCustomer,
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
    final theme = Theme.of(context);
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
              // Services Section
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.miscellaneous_services, color: Color(0xFF2f4757)),
                  SizedBox(width: 8),
                  Text(
                    'Select Services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.services.map((service) {
                  final selected = _selectedServices.contains(service);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selectedServices.remove(service);
                          _serviceQuantities.remove(service);
                        } else {
                          _selectedServices.add(service);
                          _serviceQuantities[service] = 1;
                        }
                      });
                    },
                    child: Card(
                      elevation: selected ? 6 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: selected
                            ? BorderSide(color: theme.primaryColor, width: 2)
                            : BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      color: selected ? const Color(0xfff4c345).withOpacity(0.2) : Colors.white,
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    service.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selected ? theme.primaryColor : Colors.black,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  const Icon(Icons.check_circle, color: Color(0xFF2f4757)),
                              ],
                            ),
                            if (selected)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    _QuantityStepper(
                                      value: _serviceQuantities[service]!,
                                      onChanged: (val) {
                                        setState(() {
                                          _serviceQuantities[service] = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Divider
              const SizedBox(height: 24),
              Divider(thickness: 1.2, color: Colors.grey),
              const SizedBox(height: 16),

              // Products Section
              if (widget.products.isNotEmpty) ...[
                Row(
                  children: const [
                    Icon(Icons.shopping_bag, color: Color(0xFF2f4757)),
                    SizedBox(width: 8),
                    Text(
                      'Select Products',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: widget.products.map((product) {
                    final selected = _selectedProducts.contains(product);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selected) {
                            _selectedProducts.remove(product);
                            _productQuantities.remove(product);
                          } else {
                            _selectedProducts.add(product);
                            _productQuantities[product] = 1;
                          }
                        });
                      },
                      child: Card(
                        elevation: selected ? 6 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: selected
                              ? BorderSide(color: theme.primaryColor, width: 2)
                              : BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        color: selected ? const Color(0xfff4c345).withOpacity(0.2) : Colors.white,
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: selected ? theme.primaryColor : Colors.black,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(Icons.check_circle, color: Color(0xFF2f4757)),
                                ],
                              ),
                              if (selected)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      _QuantityStepper(
                                        value: _productQuantities[product]!,
                                        onChanged: (val) {
                                          setState(() {
                                            _productQuantities[product] = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Date Picker
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Color(0xFF2f4757)),
                  title: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: \\${_selectedDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () async {
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
                ),
              ),

              // Submit Button
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _navigateToConfirmOrderPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2f4757),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToConfirmOrderPage() async {
    if (_selectedServices.isEmpty && _selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one service or product')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmOrderPage(
          selectedServices: _selectedServices,
          selectedProducts: _selectedProducts,
          selectedDate: _selectedDate!,
          existingCustomers: widget.existingCustomers,
          serviceQuantities: _serviceQuantities,
          productQuantities: _productQuantities,
          isQuickOrder: widget.isQuickOrder,
        ),
      ),
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }
}

// Add a custom quantity stepper widget for modern UI
class _QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _QuantityStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            color: Colors.grey.shade700,
            splashRadius: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => onChanged(value + 1),
            color: Colors.grey.shade700,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
