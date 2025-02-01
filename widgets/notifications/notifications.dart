import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start position (off-screen above)
      end: const Offset(0, 0), // End position (on-screen)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                thickness: 3,
                color: Color(0xfff4c345),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: ListView(
                children: [
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  _buildNotificationCard(
                    username: 'Bob Smith',
                    message: 'I need help',
                    time: '2 seconds ago',
                  ),
                  // Add more notifications here as needed
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String username,
    required String message,
    required String time,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2f4757),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
              onPressed: () {
                // Handle delete action
              },
            ),
          ],
        ),
      ),
    );
  }
}
