import 'dart:ui';

class Customer {
  String? custId;
  String name;
  String address;
  String email;
  String phoneNumber;
  String createdAt;

  Customer({
    this.custId,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.createdAt
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      custId: json['CustId']  as String?,
      name: json['Name'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      phoneNumber: json['MobileNo'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'address': address,
      'email': email,
      'MobileNo': phoneNumber,
    };
  }
}
