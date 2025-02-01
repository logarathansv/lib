import 'dart:ui';

class Customer {
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final Color labelColor;

  Customer({
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.labelColor,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'],
      address: json['address'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      labelColor: json['labelColor'],
    );
  }
}
