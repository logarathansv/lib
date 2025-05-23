import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/customer_model/customer_class.dart';
import 'package:sklyit_business/providers/chat_provider.dart';
import 'package:sklyit_business/providers/customer_provider.dart';
import 'package:sklyit_business/utils/socket/socket_service.dart';

class SelectCustomersPage extends ConsumerStatefulWidget {
  final List<HugeIcon> platformIcons; // List of platform icon paths

  const SelectCustomersPage({super.key, required this.platformIcons});

  @override
  _SelectCustomersPageState createState() => _SelectCustomersPageState();
}

class _SelectCustomersPageState extends ConsumerState<SelectCustomersPage> {
  // Store selected customer IDs or indexes
  final Set<int> _selectedIndexes = {};

  late SocketService socketService;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    socketService = SocketService();
  }

  void _sendPromotions(List<Customer> customers) async {
    // Collect selected customers
    final selectedCustomers = _selectedIndexes
        .map((index) => customers[index])
        .toList();

    if (selectedCustomers.isNotEmpty) {
      final uid = await storage.read(key: 'userId');
      final senderNameAsync = ref.watch(nameProvider);
      
      senderNameAsync.when(
            data: (senderName) => {
                socketService.socket.emit('message', {
                    'senderId': uid,
                    'receiverId': selectedCustomers.map((customer) => customer.custId).toList(),
                    "senderName": senderName,
                    "receiverName": selectedCustomers.map((customer) => customer.name).toList(),
                    'content': 'New Promotion from $senderName',
                  })
              },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error fetching name: $e')),
          );
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
    final customersAsync = ref.watch(getCustomerProvider);

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
              child: customersAsync.when(
                data: (customers) {
                  if (customers.isEmpty) {
                    return const Center(child: Text('No customers found.'));
                  }
                  return ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      final isSelected = _selectedIndexes.contains(index);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedIndexes.remove(index);
                            } else {
                              _selectedIndexes.add(index);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected ? const Color(0xfff4c345) : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ListTile(
                            title: Text(customer.name),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Color(0xFF2f4757),
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
            const SizedBox(height: 20),
            customersAsync.when(
              data: (customers) => _buildUniqueSendButton(customers),
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniqueSendButton(List<Customer> customers) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.send),
      label: const Text('Send Promotions'),
      onPressed: () => _sendPromotions(customers),
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
