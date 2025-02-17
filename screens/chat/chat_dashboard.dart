import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import '../../providers/chat_provider.dart';
import 'chat_screen.dart';

class ChatDashboard extends ConsumerStatefulWidget {
  final String uid;
  const ChatDashboard({super.key, required this.uid});

  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState extends ConsumerState<ChatDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatProvider2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => ref.refresh(chatProvider2),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(chatProvider2);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search users...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: chatMessages.when(
                data: (messages) {
                  var filteredMessages = messages
                      .where((msg) => msg.name.toLowerCase().contains(searchQuery))
                      .toList();
                  return ListView.builder(
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: filteredMessages[index].userId,
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedUserSharing,
                              color: Colors.blue,
                            ),
                            title: Text(
                              filteredMessages[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Tap to chat"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    currentUserId: widget.uid,
                                    receiverId: filteredMessages[index].userId,
                                    receiverName: filteredMessages[index].name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: Colors.grey[400]),
                          title: Container(height: 12, color: Colors.grey),
                          subtitle: Container(height: 10, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                error: (e, st) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: Icon(Icons.message),
      ),
    );
  }
}
