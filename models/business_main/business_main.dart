import 'business_followers.dart';

class Business {
  final String businessId;
  final String clientName;
  final String domainName;
  final String shopName;
  final String shopDesc;
  final String shopEmail;
  final String? shopImage;
  final String shopMobile;
  final List<String> shopLocations;
  final String shopOpenTime;
  final String shopClosingTime;
  final List<String> businessMainTags;
  final List<String> businessSubTags;
  final dynamic addresses;
  final dynamic loyaltyPts;
  final String userId;
  final String createdAt;
  final List<Follower> followers;

  Business({
    required this.businessId,
    required this.clientName,
    required this.domainName,
    required this.shopName,
    required this.shopDesc,
    required this.shopEmail,
    this.shopImage,
    required this.shopMobile,
    required this.shopLocations,
    required this.shopOpenTime,
    required this.shopClosingTime,
    required this.businessMainTags,
    required this.businessSubTags,
    this.addresses,
    this.loyaltyPts,
    required this.userId,
    required this.createdAt,
    required this.followers,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessId: json['BusinessId'],
      clientName: json['Clientname'],
      domainName: json['domainname'],
      shopName: json['shopname'],
      shopDesc: json['shopdesc'],
      shopEmail: json['shopemail'],
      shopImage: json['shopimage'],
      shopMobile: json['shopmobile'],
      shopLocations: List<String>.from(json['shopLocations'] ?? []),
      shopOpenTime: json['shopOpenTime'],
      shopClosingTime: json['shopClosingTime'],
      businessMainTags: List<String>.from(json['BusinessMainTags'] ?? []),
      businessSubTags: List<String>.from(json['BusinessSubTags'] ?? []),
      addresses: json['addresses'],
      loyaltyPts: json['loyaltypts'] == null ? null : json['loyaltypts'],
      userId: json['userId'],
      createdAt: json['created_at'],
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => Follower.fromJson(e))
          .toList() ??
          [],
    );
  }
}