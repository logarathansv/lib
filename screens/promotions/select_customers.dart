import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Customer {
  final String name;
  bool isSelected;

  Customer({required this.name, this.isSelected = false});
}

class SelectCustomersPage extends StatefulWidget {
  final List<HugeIcon> platformIcons; // List of platform icon paths

  const SelectCustomersPage({super.key, required this.platformIcons});

  @override
  _SelectCustomersPageState createState() => _SelectCustomersPageState();
}

class _SelectCustomersPageState extends State<SelectCustomersPage> {
  // Sample customer list
  final List<Customer> customers = [
    Customer(name: 'Alice Johnson'),
    Customer(name: 'Bob Smith'),
    Customer(name: 'Charlie Brown'),
    Customer(name: 'Diana Prince'),
  ];

  void _sendPromotions() {
    // Collect selected customers
    final selectedCustomers = customers
        .where((customer) => customer.isSelected)
        .map((customer) => customer.name)
        .toList();

    if (selectedCustomers.isNotEmpty) {
      // Logic to send promotions to selected customers
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Promotions sent to: ${selectedCustomers.join(', ')}!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No customers selected.')),
      );
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
          'Select Customers',
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
          children: [
            Row(
              children: [
                const Text('Sending Platforms : ',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widget.platformIcons.map((iconPath) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: iconPath);
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  return _buildCustomerCard(customers[index], index);
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildUniqueSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          customer.isSelected = !customer.isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: customer.isSelected ? const Color(0xfff4c345) : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 5),
        child: ListTile(
          title: Text(customer.name),
          trailing: customer.isSelected
              ? const Icon(
                  Icons.check,
                  color: Color(0xFF2f4757),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildUniqueSendButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.send),
      label: const Text('Send Promotions'),
      onPressed: _sendPromotions,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2f4757), // Text color
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
      ),
    );
  }
}
