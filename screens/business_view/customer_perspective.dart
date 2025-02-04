// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:sklyit_business/main.dart';
// import 'business_perspective.dart';
//
// import '../../services/services_section.dart' as services_section;
// import '../../services/products_section.dart' as products_section;
// import '../../widgets/business_page_cards/highlights_section.dart';
// import '../../widgets/business_page_cards/posts_section.dart';
// import '../../widgets/business_page_cards/search_bar.dart' as search_bar;
// import '../../widgets/business_page_cards/shop_info_card.dart';
// import '../../widgets/product_section.dart';
//
// import 'premium_template.dart';
//
// class CustomerPerspective extends StatelessWidget {
//   final String shopName;
//   final String shopDescription;
//   final String bannerImagePath;
//   final String followers;
//   final String popularity;
//   final String shopAddress;
//   final String likesCount;
//   final String rating;
//   final List<Map<String, String>> highlights;
//   final List<Map<String, dynamic>> posts;
//   final List<Map<String, dynamic>> services;
//   final List<Map<String, dynamic>> products;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // make this 'Customer view' stay there itself and not move with the scroll
//         automaticallyImplyLeading: false,
//         title: const Text('Customer View'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             tooltip: 'Edit',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SklyitApp(),
//                 ),
//               );
//             }, // Navigate to BusinessPerspective(),
//           )
//         ],
//       ),
//       extendBodyBehindAppBar: true, // AppBar floats over the banner
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
//           children: [
//             // Banner Section with Business Name and Description on Top
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Banner Image with Gradient Overlay
//                 Container(
//                   height: 400,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: FileImage(File(bannerImagePath)),
//                       fit: BoxFit.cover,
//                       onError: (error, stackTrace) => const NetworkImage(
//                         'https://via.placeholder.com/150',
//                       ),
//                     ),
//                   ),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.black.withOpacity(0.5), // Dark at the top
//                           Colors.transparent, // Transparent at the bottom
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Business Name and Description at the Top of the Banner
//                 Positioned(
//                   top: 50,
//                   // Adjust top position to prevent overlap with AppBar
//                   left: 16,
//                   right: 16,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         shopName,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           shadows: [
//                             Shadow(
//                               offset: const Offset(0, 2),
//                               blurRadius: 6.0,
//                               color: Colors.black.withOpacity(0.7),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         shopDescription,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           shadows: [
//                             Shadow(
//                               offset: const Offset(0, 2),
//                               blurRadius: 6.0,
//                               color: Colors.black.withOpacity(0.7),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Info Card Overlapping at the Bottom
//                 Positioned(
//                   bottom: -260,
//                   left: 16,
//                   right: 16,
//                   child: ShopInfoCard(
//                     followers: followers,
//                     popularity: popularity,
//                     likesCount: likesCount,
//                     shopAddress: shopAddress,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 270), // Spacing for the overlapping card
//
//             // Search Bar
//             search_bar.SearchBar(),
//
//             // Highlights Section
//             HighlightsSection(highlights: highlights),
//
//             // Posts Section
//             PostsSection(posts: posts, isCustomerView: true),
//
//             const SizedBox(height: 20),
//
//             // Services and Products Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Services',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   services_section.ServicesSection(
//                       services: services, isBusiness: false),
//                   const SizedBox(height: 20),
//                   products_section.ProductsSection(
//                       products: products, isBusiness: false),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Navigate to the premium version of the customer perspective
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PremiumTemplate(
//                 shopName: shopName,
//                 shopDescription: shopDescription,
//                 bannerImagePath: bannerImagePath,
//                 followers: followers,
//                 likesCount: likesCount,
//                 rating: rating,
//                 // Pass other necessary data to the premium version
//               ),
//             ),
//           );
//         },
//         label: Text('Try Premium'),
//         icon: Icon(Icons.star_border),
//       ),
//     );
//   }
// }
