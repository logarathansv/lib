import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  factory SocketService() => _instance;

  void initialize(String userId) {
    _socket = IO.io(
      'http://192.168.77.41:3001',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'userId': userId})
          .build(),
    );
    _socket.connect();
    _socket.onConnect((_) {
      print('Connected to WebSocket');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
    });
  }

  IO.Socket get socket => _socket;
}
