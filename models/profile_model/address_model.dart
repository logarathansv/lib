class Address {
  final String street;
  final String city;
  final String district;
  final String state;
  final String pincode;

  Address({
    required this.street,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      district: json['district'],
      state: json['state'],
      pincode: json['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
    };
  }
}