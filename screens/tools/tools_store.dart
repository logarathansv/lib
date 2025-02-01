import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ToolsPackageStorePage extends StatelessWidget {
  final List<Item> tools = [
    Item(
      name: 'Customer Tool',
      description: 'Manage customers effectively.',
      detailedDescription: '• Manage customers\n• Track customer activities',
      price: '\u{20B9}49',
      rating: 4.5,
      users: 1200,
      icon: Icons.people_outline,
    ),
    Item(
      name: 'Order Tool',
      description: 'Handle orders easily.',
      detailedDescription: '• Manage orders\n• Track order progress',
      price: '\u{20B9}39',
      rating: 4.2,
      users: 900,
      icon: Icons.shopping_cart_outlined,
    ),
    Item(
      name: 'Credit Tool',
      description: 'Manage credits for customers.',
      detailedDescription: '• Track credits\n• Manage balances',
      price: '\u{20B9}29',
      rating: 4.0,
      users: 600,
      icon: Icons.credit_card_outlined,
    ),
  ];

  final List<Item> packages = [
    Item(
      name: 'Booking Package',
      description: 'Book your services efficiently.',
      detailedDescription: '• Schedule bookings\n• Manage appointments',
      price: '\u{20B9}59',
      rating: 4.8,
      users: 1500,
      icon: Icons.event_available,
    ),
    Item(
      name: 'Event Booking Package',
      description: 'Organize events smoothly.',
      detailedDescription: '• Manage event bookings\n• Track participants',
      price: '\u{20B9}99',
      rating: 4.6,
      users: 800,
      icon: Icons.event_note_outlined,
    ),
  ];

  ToolsPackageStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Store',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
            ],
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: 'Tools'), Tab(text: 'Packages')],
          ),
        ),
        body: TabBarView(
          children: [
            ItemList(items: tools),
            ItemList(items: packages),
          ],
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<Item> items;

  const ItemList({super.key, required this.items});

  void _showBuyPopup(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            height: 250, // Increased height for better spacing
            child: Column(
              children: [
                // Top Section
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.yellow.shade300, // New light blue color
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              '${item.rating} ★',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.detailedDescription,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Section
                Container(
                  color: Colors.yellow.shade400, // Slightly darker blue
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Users Count
                      Text(
                        '${item.users} users',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      // Buy Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Purchased ${item.name} for ${item.price}')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                        ),
                        child: Text(
                          'Buy - ${item.price}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Icon(item.icon, size: 32, color: Colors.blueGrey.shade700),
                const SizedBox(width: 12),
                // Details (Name & Description)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Buy Button
                ElevatedButton(
                  onPressed: () => _showBuyPopup(context, item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Buy', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Item {
  final String name;
  final String description;
  final String detailedDescription;
  final String price;
  final double rating;
  final int users;
  final IconData icon;

  Item({
    required this.name,
    required this.description,
    required this.detailedDescription,
    required this.price,
    required this.rating,
    required this.users,
    required this.icon,
  });
}
