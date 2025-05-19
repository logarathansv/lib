import 'address_model.dart';

class BusinessProfile {
  final String clientName;
  final String domainName;
  final String shopName;
  final String shopDesc;
  final String shopEmail;
  final String shopImage;
  final String shopMobile;
  final List<Address> addresses;
  final String shopOpenTime;
  final String shopClosingTime;
  final List<String> businessMainTags;
  final List<String> businessSubTags;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final List<String> followers;
  final String? shopLocations;

  BusinessProfile({
    required this.clientName,
    required this.domainName,
    required this.shopName,
    required this.shopDesc,
    required this.shopEmail,
    required this.shopImage,
    required this.shopMobile,
    required this.addresses,
    required this.shopOpenTime,
    required this.shopClosingTime,
    required this.businessMainTags,
    required this.businessSubTags,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.followers,
    this.shopLocations,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      clientName: json['Clientname'] ?? '',
      domainName: json['domainname'] ?? '',
      shopName: json['shopname'] ?? '',
      shopDesc: json['shopdesc'] ?? '',
      shopEmail: json['shopemail'] ?? '',
      shopImage: json['shopimage'] ?? '',
      shopMobile: json['shopmobile'] ?? '',
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((address) => Address.fromJson(address))
          .toList(),
      shopOpenTime: json['shopOpenTime'] ?? '',
      shopClosingTime: json['shopClosingTime'] ?? '',
      businessMainTags:
          (json['BusinessMainTags'] as List<dynamic>? ?? []).cast<String>(),
      businessSubTags:
          (json['BusinessSubTags'] as List<dynamic>? ?? []).cast<String>(),
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      followers: (json['followers'] as List<dynamic>? ?? []).cast<String>(),
      shopLocations: json['shopLocations'] ?? '',
    );
  }
}
