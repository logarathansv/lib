import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_model/chat_message.dart';
import '../../providers/chat_provider.dart';
import '../../utils/socket/socket_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;

  ChatScreen({
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<ChatMessage> messages = [];
  String senderName = ''; // State variable to store the sender's name
  bool _isSenderNameInitialized = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeSocketListener();
    print('Socket listener initialized');

  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isSenderNameInitialized) {
      await _initializeSenderName();
      _isSenderNameInitialized = true;
    }
  }

  /// Fetch sender's name using Riverpod and set it in state
  Future<void> _initializeSenderName() async {
    final nameAsync = ref.watch(nameProvider); // Assuming `nameProvider` is declared in your providers
    nameAsync.when(
      data: (fetchedName) {
        setState(() {
          senderName = fetchedName; // Update senderName
        });
      },
      loading: () {
        print('Loading sender name...');
      },
      error: (e, st) {
        print('Error fetching sender name: $e');
      },
    );
    await _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      print(widget.receiverId);
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
            print(messages);
            isLoading = false;
          });
        },
        loading: () {
          (isLoading = false)? CircularProgressIndicator() : null;
        },
        error: (e, st) {
          // Handle error loading messages
          print("Error fetching messages: $e");
        },
      );
    } catch (e) {
      print("Error initializing chat history: $e");
    }
  }

  Future<void> _initializeSocketListener() async {


    final socket = SocketService().socket;
    // Listen to messages from the socket
    socket.on('receiveMessage', (data) {
      final newMessage = Message.fromJson(data);

      if ((newMessage.sender == widget.currentUserId && newMessage.receiver == widget.receiverId) ||
          (newMessage.receiver == widget.currentUserId && newMessage.sender == widget.receiverId)) {
        setState(() {
          messages.insert(0, ChatMessage(
            text: newMessage.content,
            user: ChatUser(id: newMessage.sender),
            createdAt: newMessage.timestamp,
          ));
        });
      }
    });

  }

  @override
  void dispose() {
    final socket = SocketService().socket;
    socket.off('receiveMessage'); // Remove listener to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socket = SocketService().socket;

    return Scaffold(
      appBar: AppBar(
        title: Text('Person ${widget.receiverName}'),
      ),
      body: isLoading ? CircularProgressIndicator() : DashChat(
        currentUser: ChatUser(id: widget.currentUserId),
        onSend: (ChatMessage newMessage) {
          if (senderName.isEmpty) {
            // Handle case where sender name is not yet loaded
            print("Sender name not loaded yet!");
            return;
          }

          socket.emit('message', {
            'senderId': widget.currentUserId,
            'receiverId': widget.receiverId,
            "senderName": senderName, // Use the fetched senderName
            "receiverName": widget.receiverName,
            'content': newMessage.text,
          });
          setState(() {
            messages.insert(0, newMessage);
          });
        },
        messages: messages,
        inputOptions: InputOptions(
          alwaysShowSend: true,
        ),
      ),
    );
  }
}
