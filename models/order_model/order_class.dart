class Order {
  final List<String> services;
  final List<Map<String, dynamic>> products; // Product name and quantity
  final String customerName;
  final double amount;
  final DateTime date_time;

  Order({
    required this.services,
    required this.products,
    required this.customerName,
    required this.amount,
    required this.date_time,
  });
}
