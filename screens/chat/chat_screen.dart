import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/chat_model/chat_message.dart';
import '../../providers/chat_provider.dart';
import '../../utils/socket/socket_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;

  const ChatScreen({super.key, 
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<ChatMessage> messages = [];
  bool isLoading = true;
  late SocketService socketService;

  @override
  void initState() {
    super.initState();
    socketService = SocketService();
    _initializeSocketListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadChatHistory();
  }

  /// Loads chat history from the provider.
  Future<void> _loadChatHistory() async {
    try {
      final chatAsync = ref.watch(chatProvider(widget.receiverId));

      chatAsync.when(
        data: (fetchedMessages) {
          setState(() {
            messages = fetchedMessages.map((message) {
              return ChatMessage(
                text: message.content,
                user: ChatUser(id: message.sender),
                createdAt: message.timestamp,
              );
            }).toList();
            isLoading = false;
          });
        },
        loading: () {
          setState(() {
            isLoading = true;
          });
        },
        error: (e, st) {
          print("Error fetching messages: $e");
          setState(() {
            isLoading = false;
          });
        },
      );
    } catch (e) {
      print("Error initializing chat history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Initializes socket listener for real-time messages.
  void _initializeSocketListener() {
    final socket = socketService.socket;

    // Remove existing listener to prevent duplication
    socket.off('receiveMessage');

    socket.on('receiveMessage', (data) {
      final newMessage = Message.fromJson(data);
      if ((newMessage.sender == widget.currentUserId && newMessage.receiver == widget.receiverId) ||
          (newMessage.receiver == widget.currentUserId && newMessage.sender == widget.receiverId)) {
        setState(() {
          messages.insert(
            0,
            ChatMessage(
              text: newMessage.content,
              user: ChatUser(id: newMessage.sender),
              createdAt: newMessage.timestamp,
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    socketService.socket.off('receiveMessage'); // Clean up socket listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.receiverId));
    final senderNameAsync = ref.watch(nameProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.invalidate(chatProvider(widget.receiverId)); // Fix missing messages after navigation
            Navigator.pop(context);
          },
          icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft03, color: Colors.black),
        ),
        title: Text(widget.receiverName),
        backgroundColor: Colors.white,
      ),
      body: chatAsync.when(
        data: (fetchedMessages) {
          if (messages.isEmpty) {
            // Prevent messages from resetting unexpectedly
            messages = fetchedMessages.map((message) {
              return ChatMessage(
                text: message.content,
                user: ChatUser(id: message.sender),
                createdAt: message.timestamp,
              );
            }).toList();
          }

          return senderNameAsync.when(
            data: (senderName) {
              return DashChat(
                currentUser: ChatUser(id: widget.currentUserId),
                onSend: (ChatMessage newMessage) {
                  if (senderName.isEmpty) return;

                  socketService.socket.emit('message', {
                    'senderId': widget.currentUserId,
                    'receiverId': widget.receiverId,
                    "senderName": senderName,
                    "receiverName": widget.receiverName,
                    'content': newMessage.text,
                  });

                  setState(() {
                    messages.insert(0, newMessage);
                  });
                },
                messages: messages,
                inputOptions: InputOptions(alwaysShowSend: true),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error fetching name: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error fetching messages: $e')),
      ),
    );
  }

}
