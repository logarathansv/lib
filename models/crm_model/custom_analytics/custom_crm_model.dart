class OrderCRM {
  final String id;
  final List<String> services;
  final double totalCost;
  final DateTime timestamp;

  OrderCRM({
    required this.id,
    required this.services,
    required this.totalCost,
    required this.timestamp,
  });
}
class CustomerCRM {
  final String name;
  final String phone;
  final String email;
  final double totalOrderValue;

  CustomerCRM({
    required this.name,
    required this.phone,
    required this.email,
    required this.totalOrderValue,
  });
}
class ProductCRM {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final int quantity;
  final double price;
  final double discount;

  ProductCRM({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.quantity,
    required this.price,
    required this.discount,
  });

  double get finalPrice => (price * quantity) * (1 - discount);
}
