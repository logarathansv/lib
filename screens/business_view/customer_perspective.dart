import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/widgets/business_page_cards/posts_section.dart';

import '../../providers/business_main.dart';
import '../../providers/product_provider.dart';
import '../../providers/service_provider.dart';
import '../../widgets/business_page_cards/shop_info_card.dart';
import '../../widgets/product_section.dart';
import '../section/services_section.dart';

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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
          children: [
            BusinessBanner(), // Widget for Business Banner
            SizedBox(height: 270), // Spacing for the overlapping card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ServicesLoader(), // Widget for Services
                  SizedBox(height: 20),
                  ProductsLoader(), // Widget for Products
                  SizedBox(height: 20),
                  PostsLoader(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessBanner extends ConsumerWidget {
  const BusinessBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(getBusinessProvider);

    return businessAsync.when(
      data: (business) {
        final imageUrl = business.shopImage?.isNotEmpty == true
            ? business.shopImage!
            : 'https://via.placeholder.com/400';

        return Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://via.placeholder.com/400',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.shopName ?? 'Shop Name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    business.shopDesc ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -260,
              left: 16,
              right: 16,
              child: ShopInfoCard(
                followers: business.followers?.length.toString() ?? '0',
                popularity: "90%", // Use dynamic if available
                likesCount: "350", // Same here
                shopAddress: (business.addresses?.first.address?? '').toString(),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load business info: $error')),
    );
  }
}

class ServicesLoader extends ConsumerWidget {
  const ServicesLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(getServicesProvider);

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return const Center(child: Text('No services available'));
        }
        return ServicesSection(services: services, isBusiness: true);
      },
      loading: () => const Center(
          child: CircularProgressIndicator(
        color: Colors.amber,
      )),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load services: $error')),
    );
  }
}

class ProductsLoader extends ConsumerWidget {
  const ProductsLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(getProductsProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('No products available'));
        }
        return ProductsSection(products: products, isBusiness: true);
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.amber)),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load products: $error')),
    );
  }
}

class PostsLoader extends ConsumerWidget {
  const PostsLoader({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postServiceProvider);
    return postsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('No posts available'));
        }
        return PostsSection(posts: posts, isCustomerView: true);
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.amber)),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load posts: $error')),
          
    );
  }
}