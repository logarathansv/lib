import 'package:flutter/material.dart';
import 'package:sklyit_business/widgets/notifications/notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrderSocketService {
  late IO.Socket _socket;

  // Private constructor
  OrderSocketService._privateConstructor();
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Singleton instance
  static final OrderSocketService _instance = OrderSocketService._privateConstructor();

  // Factory constructor
  factory OrderSocketService() => _instance;

  void initialize(String userId) {
    _socket = IO.io(
      'http://192.168.43.185:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'userId': userId})
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print('Connected to Order WebSocket');
    });

    _socket.on('shop-order-request', (data) {
      print('Received shop-order-request: $data');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => PopupPage(
              message: 'shop-order-request',
              data: data,
              onAccept: (payload) {
                _socket.emit('shop-order-accept', payload);
              },
          )
        ),
      );
    });

    

    _socket.onDisconnect((_) {
      print('Disconnected from Order WebSocket');
    });
  }

  IO.Socket get socket => _socket;
}
