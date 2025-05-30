import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sklyit_business/main.dart';
import 'package:sklyit_business/utils/socket/order_socket_service.dart';

class WaitingForCustomerScreen extends StatefulWidget {
  WaitingForCustomerScreen({super.key});

  @override
  State<WaitingForCustomerScreen> createState() =>
      _WaitingForCustomerScreenState();
}

class _WaitingForCustomerScreenState extends State<WaitingForCustomerScreen> {
  final OrderSocketService socket = OrderSocketService();

  @override
  void initState() {
    super.initState();
    socket.socket.on('order-confirmation', (data) {
      Navigator.of(context).pop(); // Close wait screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OrderConfirmedScreen(
            orderId: data['orderId'],
            message: data['message'] ?? 'Your order has been confirmed!',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular Loading Spinner
                CircularProgressIndicator(
                  color: Colors.indigo,
                  strokeWidth: 4,
                ),
                SizedBox(height: 24),

                // Title
                Text(
                  'Waiting for Customer Reply',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 12),

                // Subtitle
                Text(
                  'Please hold on while we wait for the customer to confirm your acceptance. You’ll be notified once they respond.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderConfirmedScreen extends StatefulWidget {
  final String orderId;
  final String message;

  const OrderConfirmedScreen({
    super.key,
    required this.orderId,
    required this.message,
  });

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PersonalCareBusinessPage()), (_) => false);
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    widget.message,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Order ID: ${widget.orderId}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 50,
            maxBlastForce: 30,
            minBlastForce: 5,
            gravity: 0.3,
            emissionFrequency: 0.02,
            shouldLoop: false,
            colors: [Colors.red, Colors.green, Colors.blue, Colors.purple],
          ),
        ],
      ),
    );
  }
}