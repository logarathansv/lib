import 'package:flutter_riverpod/flutter_riverpod.dart';

// Business model
class Business {
  int businessId; // Added businessId
  String shopName;
  String shopDescription;
  String shopAddress;
  String shopLocations;
  String bannerImageUrl;
  String businessType;
  String businessPhone;
  String businessWhatsapp;
  String businessEmail;

  Business({
    required this.businessId, // Added businessId
    required this.shopName,
    required this.shopDescription,
    required this.shopAddress,
    required this.shopLocations,
    required this.bannerImageUrl,
    required this.businessType,
    required this.businessPhone,
    required this.businessWhatsapp,
    required this.businessEmail,
  });
}

// BusinessNotifier class for state management
class BusinessNotifier extends StateNotifier<Business> {
  BusinessNotifier()
      : super(Business(
          businessId: 0, // Initialize with a default value
          shopName: '',
          shopDescription: '',
          shopAddress: '',
          shopLocations: '',
          bannerImageUrl: '',
          businessType: '',
          businessPhone: '',
          businessWhatsapp: '',
          businessEmail: '',
        ));

  // Method to update businessId
  void updateBusinessId(int newBusinessId) {
    state = state.copyWith(businessId: newBusinessId);
  }

  // Method to update shopName
  void updateShopName(String newName) {
    state = state.copyWith(shopName: newName);
  }

  // Method to update shopDescription
  void updateShopDescription(String newDescription) {
    state = state.copyWith(shopDescription: newDescription);
  }

  // Method to update shopAddress
  void updateShopAddress(String newAddress) {
    state = state.copyWith(shopAddress: newAddress);
  }

  // Method to update shopLocations
  void updateShopLocations(String newLocations) {
    state = state.copyWith(shopLocations: newLocations);
  }

  // Method to update bannerImageUrl
  void updateBannerImageUrl(String newImageUrl) {
    state = state.copyWith(bannerImageUrl: newImageUrl);
  }

  // Method to update businessType
  void updateBusinessType(String newBusinessType) {
    state = state.copyWith(businessType: newBusinessType);
  }

  // Method to update businessPhone
  void updateBusinessPhone(String newBusinessPhone) {
    state = state.copyWith(businessPhone: newBusinessPhone);
  }

  // Method to update businessWhatsapp
  void updateBusinessWhatsapp(String newBusinessWhatsapp) {
    state = state.copyWith(businessWhatsapp: newBusinessWhatsapp);
  }

  // Method to update businessEmail
  void updateBusinessEmail(String newBusinessEmail) {
    state = state.copyWith(businessEmail: newBusinessEmail);
  }
}

// Extension for copying the state easily (optional)
extension on Business {
  Business copyWith({
    int? businessId, // Added businessId
    String? shopName,
    String? shopDescription,
    String? shopAddress,
    String? shopLocations,
    String? bannerImageUrl,
    String? businessType,
    String? businessPhone,
    String? businessWhatsapp,
    String? businessEmail,
  }) {
    return Business(
      businessId: businessId ?? this.businessId, // Added businessId
      shopName: shopName ?? this.shopName,
      shopDescription: shopDescription ?? this.shopDescription,
      shopAddress: shopAddress ?? this.shopAddress,
      shopLocations: shopLocations ?? this.shopLocations,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      businessType: businessType ?? this.businessType,
      businessPhone: businessPhone ?? this.businessPhone,
      businessWhatsapp: businessWhatsapp ?? this.businessWhatsapp,
      businessEmail: businessEmail ?? this.businessEmail,
    );
  }
}

// Provider declaration
final businessProvider =
    StateNotifierProvider<BusinessNotifier, Business>((ref) {
  return BusinessNotifier();
});
