class CustomerRevenue {
  final String name;
  final int value;

  CustomerRevenue({required this.name, required this.value});

  factory CustomerRevenue.fromJson(Map<String, dynamic> json) {
    return CustomerRevenue(
      name: json['customername'],
      value: json['totalCost'],
    );
  }
}

class CustomerPercentage {
  final String type;
  final double value;
  CustomerPercentage({required this.type, required this.value});
  factory CustomerPercentage.fromJson(Map<String, dynamic> json) {
    return CustomerPercentage(
      type: json['customer_type'],
      value: json['total_revenue'],
    );
  }
}