import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/service/service_screen.dart';
import 'package:sklyit_business/screens/tools/tools_store.dart';

import '../booking_management/booking_list.dart';
import '../crm/crm_main.dart';
import '../inventory/inventory_page.dart';
import '../orders/orders_list.dart';
import '../customers/customer_list.dart';
import '../promotions/promotions_selection.dart';

class ShowToolsPage extends StatefulWidget {
  const ShowToolsPage({super.key});

  @override
  _ShowToolsPageState createState() => _ShowToolsPageState();
}

class _ShowToolsPageState extends State<ShowToolsPage> {
  final List<String> _iconname = [
    "Customers",
    "Orders",
    "Bookings",
    "Promotions",
    "CRM",
    "Inventory",
    "Services"
  ];
  final List<HugeIcon> _icons = [
    const HugeIcon(
      icon: HugeIcons.strokeRoundedUser,
      color: Colors.blue,
      size: 30,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBasket01,
      color: Colors.deepOrangeAccent,
      size: 24.0,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedCalendar02,
      color: Colors.pink,
      size: 24.0,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedPromotion,
      color: Colors.deepPurpleAccent,
      size: 24.0,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedDashboardSpeed01,
      color: Colors.brown,
      size: 24.0,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedWarehouse,
      color: Color(0xfff4c345),
      size: 24.0,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedActivity01,
      color: Colors.blue,
      size: 24.0,
    )
  ];
  final List<Widget> _pages = [
    AddCustomerPage(),
    AddOrdersPage(),
    BookingPage(),
    PromotionsPage(),
    CRMPage(),
    InventoryPage(),
    ServicePage(),
  ];

  // Shortcut icons and their actions
  final List<String> _shortcutNames = [
    "Add Customer",
    "Add Order",
    "Add Product",
  ];
  final List<HugeIcon> _shortcutIcons = [
    const HugeIcon(
      icon: HugeIcons.strokeRoundedUserAdd01,
      color: Colors.blue,
      size: 24.0,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBasketAdd01,
      color: Colors.deepOrangeAccent,
      size: 24.0,
    ),
    const HugeIcon(
      icon: HugeIcons.strokeRoundedProductLoading,
      color: Colors.green,
      size: 24.0,
    ),
  ];

  List<VoidCallback> _shortcutActions(BuildContext context) {
    return [
      () {
        // Navigate to AddCustomerPage and trigger the "Add Customer" button automatically
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddCustomerPage(autoTriggerAddCustomer: true),
            transitionDuration: const Duration(milliseconds: 100),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0), // Slide from the right
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
      () {
        // Navigate to AddOrdersPage and then automatically to AddOrderPage
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddOrdersPage(autoTriggerAddOrder: true),
            transitionDuration: const Duration(milliseconds: 100),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0), // Slide from the right
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
      () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const InventoryPage(autoTriggerAddProduct: true),
            transitionDuration: const Duration(milliseconds: 100),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0), // Slide from the right
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  'Tools',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                thickness: 3,
                color: Color(0xfff4c345),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Existing Tools Grid
            Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      _pages[index],
                                  transitionDuration:
                                      const Duration(milliseconds: 100),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: const Offset(0, 0),
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: _icons[index],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _iconname[index],
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Divider to emphasize the shortcuts section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            ),
            // Shortcuts Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _shortcutIcons.length,
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: _shortcutActions(context)[index],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: _shortcutIcons[index],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _shortcutNames[index],
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Animated Button at the right bottom
      floatingActionButton: TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        builder: (context, offset, child) {
          return SlideTransition(
            position: AlwaysStoppedAnimation<Offset>(offset),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ToolsPackageStorePage(),
                    transitionDuration: const Duration(milliseconds: 600),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                width: 200,
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
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
                      "Tools Store",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
