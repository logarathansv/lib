import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:sklyit_business/models/flash_model/flash_product.dart';
import 'package:sklyit_business/models/order_model/flash_order_model.dart';

import './order_details_page.dart';

class FlashScreen extends StatefulWidget {
  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<FlashScreen> {
  bool isPacked = false;
  bool isHandedOver = false;

  String formatDateTime(DateTime dateTime) {
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String formattedDate = DateFormat("E, d MMM ''yy - h:mm a").format(dateTime);
    String day = DateFormat("d").format(dateTime);
    String suffix = daySuffix(int.parse(day));

    return formattedDate.replaceFirst(RegExp(r'\d{1,2}'), '$day$suffix');
  }

  void markPacked() {
    setState(() {
      isPacked = true;
    });
  }

  void markHandedOver() {
    setState(() {
      isHandedOver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Order Tracking',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1A237E)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1A237E).withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      "Order ID: #123456",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              OrderStep(
                title: "Order Confirmed",
                subtitle: "Your order has been placed.",
                timestamp: formatDateTime(DateTime.now()),
                isCompleted: true,
              ),
              OrderStep(
                title: "Packed Items in Order",
                subtitle: "Your items have been packed.",
                timestamp: formatDateTime(DateTime.now()),
                isCompleted: isPacked,
                showButton: !isPacked,
                onDone: markPacked,
              ),
              if (isPacked)
                OrderStep(
                  title: "Handed Over to Delivery Person",
                  subtitle: "Your item is with the delivery person.",
                  timestamp: formatDateTime(DateTime.now()),
                  isCompleted: isHandedOver,
                  showButton: !isHandedOver,
                  onDone: markHandedOver,
                ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF00695C)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00897B).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Add navigation logic here
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            "View Order Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowRight05,
                            color: Colors.white,
                            size: 24.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFA000).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.history, color: Color(0xFFFFA000)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Past Orders",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              PastOrderCard(
                deliveryDate: "9th Mar '24",
                firstItem: "Wireless Mouse",
                totalItems: 3,
                order: FlashOrderModel(
                  flashid: "1",
                  customerId: "1",
                  orderDate: DateTime.now().toString(),
                  totalAmount: "100.0",
                  products: [
                    FlashProduct(
                      id: "1",
                      name: "Wireless Mouse",
                      price: "100.0",
                      quantity: "3",
                      units: "1",
                    ),
                    FlashProduct(
                      id: "2",
                      name: "Wireless Mouse",
                      price: "100.0",
                      quantity: "3",
                      units: "1",
                    ),
                  ],
                  customerName: "John Doe",
                  customerMobile: "1234567890",
                  customerAddress: "123 Main St, Anytown, USA",
                  customerEmail: "john.doe@example.com",
                  orderId: "1",
                  shopName: "John's Shop",
                  shopAddress: "123 Main St, Anytown, USA",
                  shopPhoneNumber: "1234567890",
                  shopEmail: "john.doe@example.com",
                ),
              ),
              PastOrderCard(
                deliveryDate: "25th Feb '24",
                firstItem: "Bluetooth Speaker",
                totalItems: 2,
                order: FlashOrderModel(
                  flashid: "2",
                  customerId: "2",
                  orderDate: DateTime.now().toString(),
                  totalAmount: "100.0",
                  products: [
                    FlashProduct(
                      id: "1",
                      name: "Wireless Mouse",
                      price: "100.0",
                      quantity: "3",
                      units: "1",
                    ),
                  ],
                  customerName: "John Doe",
                  customerMobile: "1234567890",
                  customerAddress: "123 Main St, Anytown, USA",
                  customerEmail: "john.doe@example.com",
                  orderId: "2",
                  shopName: "John's Shop",
                  shopAddress: "123 Main St, Anytown, USA",
                  shopPhoneNumber: "1234567890",
                  shopEmail: "john.doe@example.com",
                ),
              ),
              PastOrderCard(
                deliveryDate: "12th Feb '24",
                firstItem: "Smartphone Case",
                totalItems: 5,
                order: FlashOrderModel(
                  flashid: "3",
                  customerId: "3",
                  orderDate: DateTime.now().toString(),
                  totalAmount: "100.0",
                  products: [
                    FlashProduct(
                      id: "1",
                      name: "Wireless Mouse",
                      price: "100.0",
                      quantity: "3",
                      units: "1",
                    ),
                  ],
                  customerName: "John Doe",
                  customerMobile: "1234567890",
                  customerAddress: "123 Main St, Anytown, USA",
                  customerEmail: "john.doe@example.com",
                  orderId: "3",
                  shopName: "John's Shop",
                  shopAddress: "123 Main St, Anytown, USA",
                  shopPhoneNumber: "1234567890",
                  shopEmail: "john.doe@example.com",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timestamp;
  final bool isCompleted;
  final bool showButton;
  final VoidCallback? onDone;

  OrderStep({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.isCompleted = false,
    this.showButton = false,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Color(0xFF00897B).withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: isCompleted ? Color(0xFF00897B) : Colors.grey,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted ? Color(0xFF00897B) : Colors.grey,
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCompleted ? Color(0xFF00897B) : Color(0xFF1A237E),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              if (showButton)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFA000), Color(0xFFFFB300)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFFA000).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onDone,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class PastOrderCard extends StatelessWidget {
  final String deliveryDate;
  final String firstItem;
  final int totalItems;
  final FlashOrderModel order;

  PastOrderCard({
    required this.deliveryDate,
    required this.firstItem,
    required this.totalItems,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderDetailsPage(order: order)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderDetailsPage(order: order)),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF00897B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF00897B),
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivered on $deliveryDate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$firstItem + ${totalItems - 1} more items",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFF00897B),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}