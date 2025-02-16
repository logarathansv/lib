import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/order_model/order_model.dart';
import 'package:sklyit_business/models/order_model/services_class.dart';
import '../../models/customer_model/customer_class.dart';
import '../../models/product_model/product_model.dart';

class ConfirmOrderPage extends StatefulWidget {
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

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
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
                    child: Text(customer.name),
                  );
                }).toList(),
                onChanged: (Customer? value) {
                  setState(() {
                    _selectedCustomer = value;
                    if (value != null) {
                      _customerNameController.text = value.name;
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
              const SizedBox(height: 8),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a customer name';
                  }
                  return null;
                },
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new order
      // final newOrder = Order(
      //   services: widget.selectedServices.map((e) => e.name).toList(),
      //   products: widget.selectedProducts
      //       .map((e) => {'name': e.name, 'quantity': e.quantity})
      //       .toList(),
      //   customerName: _customerNameController.text,
      //   amount: double.parse(_amountController.text),
      //   date_time: widget.selectedDate,
      // );

      // Return the new order to the previous page
      // Navigator.of(context).pop(newOrder);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }
}
