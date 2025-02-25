import 'package:flutter/material.dart';
import '../../models/service_model/service_model.dart';
import '../../models/customer_model/customer_class.dart';

class ServiceSelectionDialog extends StatefulWidget {
  final List<Service> services;
  final List<Customer> existingCustomers;

  const ServiceSelectionDialog({
    super.key,
    required this.services,
    required this.existingCustomers,
  });

  @override
  _ServiceSelectionDialogState createState() => _ServiceSelectionDialogState();
}

class _ServiceSelectionDialogState extends State<ServiceSelectionDialog> {
  List<Service> selectedServices = [];
  Customer? selectedCustomer;

  // Controllers for creating a new customer
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isCreatingNewCustomer = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Services and Customer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Service Selection
            Wrap(
              children: widget.services.map((service) {
                return ChoiceChip(
                  label: Text(service.name),
                  selected: selectedServices.contains(service),
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedServices.add(service);
                      } else {
                        selectedServices.remove(service);
                      }
                    });
                  },
                  selectedColor: const Color(0xfff4c345),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Customer Selection
            DropdownButtonFormField<Customer>(
              hint: const Text('Select an existing customer'),
              value: selectedCustomer,
              items: widget.existingCustomers.map((customer) {
                return DropdownMenuItem<Customer>(
                  value: customer,
                  child: Row(
                    children: [
                      Text(customer.name),
                      const SizedBox(width: 10),
                      Text(customer.email),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (customer) {
                setState(() {
                  selectedCustomer = customer;
                  isCreatingNewCustomer = false; // Hide new customer fields
                });
              },
            ),
            Row(
              children: [
                const Text('Create a new customer: '),
                Checkbox(
                  value: isCreatingNewCustomer,
                  onChanged: (value) {
                    setState(() {
                      isCreatingNewCustomer = value ?? false;
                      selectedCustomer = null; // Reset selected customer
                      if (isCreatingNewCustomer) {
                        nameController.clear();
                        addressController.clear();
                        phoneController.clear();
                        emailController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            if (isCreatingNewCustomer) ...[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address (Optional)',
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Ensure user has selected or created a customer
            if (selectedCustomer == null && nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    'Please select an existing customer or enter a new customer name!'),
                backgroundColor: Colors.red,
              ));
              return;
            }

            // Prepare the result to be passed back
            Customer customerToReturn;
            if (isCreatingNewCustomer) {
              // Create a new customer
              customerToReturn = Customer(
                name: nameController.text,
                address: addressController.text,
                phoneNumber: phoneController.text,
                email: emailController.text,
                createdAt: DateTime.now().toString(), // Default color
              );
            } else {
              customerToReturn = selectedCustomer!;
            }

            Navigator.of(context).pop({
              'services': selectedServices,
              'customer': customerToReturn,
            });
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
