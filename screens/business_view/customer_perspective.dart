import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/main.dart';
import 'package:sklyit_business/models/product_model/product_model.dart';
import '../../models/business_main/business_main.dart';
import '../../providers/business_main.dart';
import '../../providers/product_provider.dart';
import '../../providers/service_provider.dart';
import '../section/services_section.dart';
import 'business_perspective.dart';
import '../../widgets/business_page_cards/search_bar.dart' as search_bar;
import '../../widgets/business_page_cards/shop_info_card.dart';
import '../../widgets/product_section.dart';
import 'premium_template.dart';

class CustomerPerspective extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, // AppBar floats over the banner
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
          children: [
            BusinessBanner(), // Widget for Business Banner
            const SizedBox(height: 270), // Spacing for the overlapping card
            search_bar.SearchBar(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ServicesLoader(), // Widget for Services
                  const SizedBox(height: 20),
                  ProductsLoader(), // Widget for Products
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the premium version of the customer perspective
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PremiumTemplate(
                shopName: "Shop Name", // Placeholder, will be replaced in BusinessBanner
                shopDescription: "Shop Description", // Placeholder
                bannerImagePath: "", // Placeholder
                followers: "0", // Placeholder
                likesCount: "350",
                rating: "90%",
              ),
            ),
          );
        },
        label: Text('Try Premium'),
        icon: Icon(Icons.star_border),
      ),
    );
  }
}

// ==================== Business Banner Widget ====================
class BusinessBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(getBusinessProvider); // ✅ Correct way

    return businessAsync.when(
      data: (business) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Banner Image with Gradient Overlay
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(business.shopImage ?? ''),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) => const NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Business Name and Description
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.shopName ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    business.shopDesc ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Info Card Overlapping at the Bottom
            Positioned(
              bottom: -260,
              left: 16,
              right: 16,
              child: ShopInfoCard(
                followers: business.followers.length.toString() ?? '0',
                popularity: "90%",
                likesCount: "350",
                shopAddress: business.shopLocations.toString() ?? '',
              ),
            ),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()), // ✅ Show loader while fetching
      error: (error, stackTrace) => Center(child: Text('Failed to load business info: $error')), // ✅ Show error message
    );
  }
}


// ==================== Services Loader Widget ====================
class ServicesLoader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(getServicesProvider); // ✅ Correct way

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return Center(child: Text('No services available'));
        }
        return ServicesSection(services: services, isBusiness: true);
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Failed to load services: $error')),
    );
  }
}


// ==================== Products Loader Widget ====================
class ProductsLoader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(getProductsProvider); // ✅ Correct way to handle async data

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(child: Text('No products available'));
        }
        return ProductsSection(products: products, isBusiness: true);
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Failed to load products: $error')),
    );
  }
}
