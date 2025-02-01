import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> ongoingChats = [
    {
      'name': 'Alice',
      'lastMessage': 'Can you confirm my booking?',
      'time': '10:30 AM'
    },
    {
      'name': 'Bob',
      'lastMessage': 'I have a few questions.',
      'time': 'Yesterday'
    },
  ];

  final List<Map<String, dynamic>> previousChats = [
    {
      'name': 'Eve',
      'lastMessage': 'Thank you for your service!',
      'time': 'Last Week'
    },
    {
      'name': 'John',
      'lastMessage': 'Order completed successfully.',
      'time': '2 weeks ago'
    },
  ];

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Chat to Customers', // The unstyled part
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(47, 72, 88, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: const Color(0xFF2f4757),
                child: const TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text('Ongoing',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    Tab(
                      child: Text('Previous',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildChatList(context, ongoingChats),
                    _buildChatList(context, previousChats),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildChatList(
      BuildContext context, List<Map<String, dynamic>> chats) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xfff4c345),
            child: Text(chat['name'][0],
                style: const TextStyle(color: Colors.white)),
          ),
          title: Text(chat['name']),
          subtitle: Text(chat['lastMessage']),
          trailing:
              Text(chat['time'], style: const TextStyle(color: Colors.grey)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatDetailScreen(customerName: chat['name']),
              ),
            );
          },
        );
      },
    );
  }
}
