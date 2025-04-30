import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/service/service_screen.dart';
import 'package:sklyit_business/screens/tools/tools_store.dart';

import '../booking_management/booking_list.dart';
import '../crm/crm_main.dart';
import '../customers/customer_list.dart';
import '../inventory/inventory_page.dart';
import '../orders/orders_list.dart';
import '../promotions/promotions_selection.dart';

class ShowToolsPage extends StatefulWidget {
  const ShowToolsPage({super.key});

  @override
  _ShowToolsPageState createState() => _ShowToolsPageState();
}

class _ShowToolsPageState extends State<ShowToolsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _currentSlide = 0;

  final List<Map<String, dynamic>> _featuredTools = [
    {
      'title': 'Premium CRM Suite',
      'description': 'Advanced customer relationship management tools',
      'price': '\$49.99/month',
      'image': 'assets/images/crm_premium.png',
      'color': Color(0xFF2196F3),
    },
    {
      'title': 'Inventory Pro',
      'description': 'Complete inventory management solution',
      'price': '\$39.99/month',
      'image': 'assets/images/inventory_pro.png',
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Business Analytics',
      'description': 'Advanced analytics and reporting tools',
      'price': '\$59.99/month',
      'image': 'assets/images/analytics.png',
      'color': Color(0xFF9C27B0),
    },
  ];

  final List<Map<String, dynamic>> _tools = [
    {
      'title': 'Customers',
      'icon': HugeIcons.strokeRoundedUser,
      'description': 'Manage your customer database',
      'page': AddCustomerPage(),
    },
    {
      'title': 'Orders',
      'icon': HugeIcons.strokeRoundedShoppingBasket01,
      'description': 'Track and manage orders',
      'page': AddOrdersPage(),
    },
    {
      'title': 'Bookings',
      'icon': HugeIcons.strokeRoundedCalendar02,
      'description': 'Schedule and manage appointments',
      'page': BookingPage(),
    },
    {
      'title': 'Promotions',
      'icon': HugeIcons.strokeRoundedPromotion,
      'description': 'Create and manage promotions',
      'page': PromotionsPage(),
    },
    {
      'title': 'CRM',
      'icon': HugeIcons.strokeRoundedDashboardSpeed01,
      'description': 'Customer relationship management',
      'page': CRMPage(),
    },
    {
      'title': 'Inventory',
      'icon': HugeIcons.strokeRoundedWarehouse,
      'description': 'Manage your inventory',
      'page': InventoryPage(),
    },
    {
      'title': 'Services',
      'icon': HugeIcons.strokeRoundedActivity01,
      'description': 'Manage your services',
      'page': ServicePage(),
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'title': 'Add Customer',
      'icon': HugeIcons.strokeRoundedUserAdd01,
      'action': (context) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddCustomerPage(autoTriggerAddCustomer: true),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
    },
    {
      'title': 'Add Order',
      'icon': HugeIcons.strokeRoundedShoppingBasketAdd01,
      'action': (context) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddOrdersPage(autoTriggerAddOrder: true),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
    },
    {
      'title': 'Add Product',
      'icon': HugeIcons.strokeRoundedProductLoading,
      'action': (context) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const InventoryPage(autoTriggerAddProduct: true),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'Tools',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2196F3),
                      const Color(0xFF9C27B0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Featured Tools Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16/9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayInterval: Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSlide = index;
                    });
                  },
                ),
                items: _featuredTools.map((tool) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              tool['color'],
                              tool['color'].withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: tool['color'].withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tool['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                tool['description'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tool['price'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigate to purchase page
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: tool['color'],
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text('Get Started'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _featuredTools.asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor.withOpacity(
                        _currentSlide == entry.key ? 0.9 : 0.4,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Tools Store Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ToolsPackageStorePage(),
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedStore02,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Explore Tools Store",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Main Tools Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Business Tools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _tools.length,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              _tools[index]['page'],
                                          transitionDuration: const Duration(milliseconds: 300),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          HugeIcon(
                                            icon: _tools[index]['icon'],
                                            color: Color(0xFF2C3E50),
                                            size: 32,
                                          ),
                                          const Spacer(),
                                          Text(
                                            _tools[index]['title'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2C3E50),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Quick Actions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _quickActions.length,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _quickActions[index]['action'](context),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        HugeIcon(
                                          icon: _quickActions[index]['icon'],
                                          color: Color(0xFF2C3E50),
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _quickActions[index]['title'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2C3E50),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
