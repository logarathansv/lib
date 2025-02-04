import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/services_section.dart' as services_section;
import '../services/products_section.dart' as products_section;
import '../premium/highlights_premium.dart';
import '../premium/follower_like_rating.dart';
import '../../utils/moving_text.dart';

class PremiumTemplate extends StatefulWidget {
  final String shopName;
  final String shopDescription;
  final String bannerImagePath;
  final String followers;
  final String likesCount;
  final String rating;
  final List<Map<String, String>> highlights;
  final List<Map<String, dynamic>> popularItems;
  final List<Map<String, dynamic>> services;
  final List<Map<String, dynamic>> products;
  final List<Map<String, String>> updates;

  const PremiumTemplate({
    Key? key,
    required this.shopName,
    required this.shopDescription,
    required this.bannerImagePath,
    required this.followers,
    required this.likesCount,
    required this.rating,
    this.highlights = const [],
    this.popularItems = const [],
    this.services = const [],
    this.products = const [],
    this.updates = const [],
  }) : super(key: key);

  @override
  _PremiumTemplateState createState() => _PremiumTemplateState();
}

class _PremiumTemplateState extends State<PremiumTemplate> {
  bool isLightBrownTheme = false;

  void toggleTheme() {
    setState(() {
      isLightBrownTheme = !isLightBrownTheme; // Toggle theme
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          isLightBrownTheme ? Colors.brown[300] : Colors.brown.shade800,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Color bodyColor =
        isLightBrownTheme ? Colors.brown[300]! : Colors.brown.shade800;

    return Scaffold(
      body: Container(
        color: bodyColor, // Keeping the original background color
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerSection(),
              FollowerLikeRatingPage(
                  followers: widget.followers,
                  likesCount: widget.likesCount,
                  rating: widget.rating,
                  bodyColor: bodyColor),

              // Darkening gradient from existing background color to black
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      bodyColor,
                      Colors.black
                    ], // Gradient from existing color to black
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    HighlightsPremium(highlights: _getSampleHighlights()),
                    _buildPromotionLine(),
                  ],
                ),
              ),

              // Reset to normal for Popular Items section
              _buildPopularItemsSection(),
              SectionTitle(title: 'Services'),
              services_section.ServicesSection(
                services: _getSampleServices(),
                isBusiness: false,
              ),
              SectionTitle(title: 'Products'),
              products_section.ProductsSection(
                products: _getSampleProducts(),
                isBusiness: false,
              ),
              SectionTitle(title: 'Latest Updates'),
              //UpdatesSection(updates: _getSampleUpdates()), // Placeholder data
            ],
          ),
        ),
      ),
    );
  }

  // Modularized Popup Menu Items
  List<PopupMenuEntry<String>> _buildPopupMenuItems() {
    return <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'Home',
        child: Text('Home', style: TextStyle(color: Colors.white)),
      ),
      const PopupMenuItem<String>(
        value: 'Business Stat',
        child: Text('Business Stat', style: TextStyle(color: Colors.white)),
      ),
      const PopupMenuItem<String>(
        value: 'Highlights',
        child: Text('Highlights', style: TextStyle(color: Colors.white)),
      ),
      const PopupMenuItem<String>(
        value: 'Popular',
        child: Text('Popular', style: TextStyle(color: Colors.white)),
      ),
      const PopupMenuItem<String>(
        value: 'Services',
        child: Text('Services', style: TextStyle(color: Colors.white)),
      ),
      const PopupMenuItem<String>(
        value: 'Products',
        child: Text('Products', style: TextStyle(color: Colors.white)),
      ),
      const PopupMenuItem<String>(
        value: 'Updates',
        child: Text('Updates', style: TextStyle(color: Colors.white)),
      ),
      const PopupMenuItem<String>(
        value: 'Reviews',
        child: Text('Reviews', style: TextStyle(color: Colors.white)),
      ),
    ];
  }

  // Modularized Banner Section
  Widget _buildBannerSection() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(widget.bannerImagePath)),
              fit: BoxFit.cover,
              onError: (error, stackTrace) =>
                  const NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to ${widget.shopName}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.shopDescription,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Modularized Promotion Line
  Widget _buildPromotionLine() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.05,
        child: MovingText(
          text: "This is the long promotion line which is animatedly scrolling",
        ));
  }

  // Modularized Popular Items Section
  Widget _buildPopularItemsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Items',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PopularItemCard(),
                PopularItemCard(),
                PopularItemCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getSampleServices() {
    return [
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'name': 'Service 1',
        'description': 'Description for Service 1',
        'price': '100',
        'isPopular': true,
      },
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'name': 'Service 2',
        'description': 'Description for Service 2',
        'price': '200',
        'isPopular': false,
      },
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'name': 'Service 3',
        'description': 'Description for Service 3',
        'price': '300',
        'isPopular': false,
      },
    ];
  }

  List<Map<String, dynamic>> _getSampleProducts() {
    return [
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'name': 'Product 1',
        'description': 'Description for Product 1',
        'price': '50',
      },
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'name': 'Product 2',
        'description': 'Description for Product 2',
        'price': '70',
      },
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'name': 'Product 3',
        'description': 'Description for Product 3',
        'price': '30',
      },
    ];
  }

  List<Map<String, String>> _getSampleUpdates() {
    return [
      {'title': 'Update 1', 'content': 'Details about update 1'},
      {'title': 'Update 2', 'content': 'Details about update 2'},
      {'title': 'Update 3', 'content': 'Details about update 3'},
    ];
  }

  List<Map<String, String>> _getSampleHighlights() {
    return [
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'title': 'Highlight 1',
        'description': 'Details about highlight 1',
      },
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'title': 'Highlight 2',
        'description': 'Details about highlight 2',
      },
      {
        'imageUrl': 'https://via.placeholder.com/150',
        'title': 'Highlight 3',
        'description': 'Details about highlight 3',
      },
    ];
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class PopularItemCard extends StatelessWidget {
  const PopularItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Image.network('https://via.placeholder.com/150',
              height: 100, fit: BoxFit.cover),
          const Text('Item Title',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Item Description', style: TextStyle(color: Colors.grey)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('\$99.99',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton(onPressed: () {}, child: const Text('Book Now')),
            ],
          ),
        ],
      ),
    );
  }
}
