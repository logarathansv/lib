import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sklyit_business/models/flash_model/flash_product.dart';
import 'package:sklyit_business/models/order_model/flash_order_model.dart';


class OrderDetailsPage extends StatelessWidget {
  final FlashOrderModel order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Order Details',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            _buildDeliveryDetails(),
            _buildProductsList(),
            _buildOrderSummary(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.orderId}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                child: Text(
                  'Processing',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.white70),
              SizedBox(width: 8),
              Text(
                'Ordered on ${_formatDate(order.orderDate)}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00897B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.local_shipping_outlined, color: Color(0xFF00897B)),
              ),
              SizedBox(width: 12),
              Text(
                'Delivery Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.person_outline,
            title: 'Customer',
            value: order.customerName,
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Delivery Address',
            value: order.customerAddress,
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            title: 'Contact',
            value: order.customerMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFFFA000).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.shopping_bag_outlined, color: Color(0xFFFFA000)),
              ),
              SizedBox(width: 12),
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...order.products.map((FlashProduct product) => _buildProductItem(product)),
        ],
      ),
    );
  }

  Widget _buildProductItem(FlashProduct product) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: Color(0xFF00897B),
                size: 32,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFA000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Quantity: ${product.quantity} ${product.units}',
                    style: TextStyle(
                      color: Color(0xFFFFA000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '₹${product.price}',
                  style: TextStyle(
                    color: Color(0xFF00897B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1A237E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt_long_outlined, color: Color(0xFF1A237E)),
              ),
              SizedBox(width: 12),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSummaryRow('Subtotal', '₹${order.totalAmount}'),
          SizedBox(height: 12),
          _buildSummaryRow('Delivery Fee', '₹0'),
          Divider(height: 32, thickness: 1, color: Color(0xFFE0E0E0)),
          _buildSummaryRow(
            'Total Amount',
            '₹${order.totalAmount}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF00897B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Color(0xFF00897B)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: Color(0xFF1A237E),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Color(0xFF00897B) : Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
} 