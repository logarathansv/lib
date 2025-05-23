import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/orders/add_orders_page.dart';

import '../../models/customer_model/customer_class.dart';
import '../../models/order_model/order_model.dart';
import '../../models/product_model/product_model.dart'; // Import the Product class
import '../../models/service_model/service_model.dart';
import '../../providers/customer_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/service_provider.dart';
import 'order_details.dart';

class AddOrdersPage extends ConsumerStatefulWidget {
  final bool autoTriggerAddOrder;
  final Customer? quickOrderCustomer;

  const AddOrdersPage({
    super.key,
    this.autoTriggerAddOrder = false,
    this.quickOrderCustomer,
  });

  @override
  ConsumerState<AddOrdersPage> createState() => _AddOrdersPageState();
}

class _AddOrdersPageState extends ConsumerState<AddOrdersPage>
    with SingleTickerProviderStateMixin {
  List<Order> orders = [];
  final _searchController = TextEditingController();
  List<Customer> customers = [];
  List<Service> services = [];
  List<Product> products = [];
  List<Order> _searchResults = [];
  String _filterType = 'All';
  late final TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
    if (widget.autoTriggerAddOrder) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToAddOrderPage();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void getServices() async {
    final servicesAsync = ref.watch(getServicesProvider);
    servicesAsync.when(
      data: (fetchedServices) {
        setState(() {
          services = fetchedServices;
        });
      },
      error: (error, stackTrace) {
        print("Error Loading services: $error , $stackTrace");
        return [];
      },
      loading: () => CircularProgressIndicator(),
    );
  }

  void getProducts() async {
    final productsAsync = ref.watch(getProductsProvider);
    productsAsync.when(
      data: (fetchedProducts) {
        setState(() {
          products = fetchedProducts;
        });
      },
      error: (error, stackTrace) {
        print("Error Loading products: $error");
        return [];
      },
      loading: () => CircularProgressIndicator(),
    );
  }

  void getCustomers() async {
    final customersAsync = ref.watch(getCustomerProvider);
    customersAsync.when(
      data: (fetchedCustomers) {
        setState(() {
          customers = fetchedCustomers;
        });
      },
      error: (error, stackTrace) {
        print("Error Loading customers: $error");
        return [];
      },
      loading: () => CircularProgressIndicator(),
    );
  }

  void _navigateToAddOrderPage() async {
    final newOrder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrderPage(
          services: services,
          products: products,
          existingCustomers: customers,
          isQuickOrder: widget.quickOrderCustomer != null,
          quickOrderCustomer: widget.quickOrderCustomer,
        ),
      ),
    );

    if (newOrder != null) {
      setState(() {
        orders.add(newOrder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(getOrdersProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          ordersAsync.when(
            data: (fetchedServices) {
              orders = fetchedServices;
              getServices();
              getProducts();
              getCustomers();
              return _buildContent();
            },
            error: (error, stackTrace) {
              print("Error Loading services: $error");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading orders: $error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff4c345)),
              ),
            ),
          ),
          // Floating plus button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF2f4757),
              onPressed: () async {
                final newOrder = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrderPage(
                      services: services,
                      products: products,
                      existingCustomers: customers,
                      isQuickOrder: _currentTabIndex == 1,
                      quickOrderCustomer: _currentTabIndex == 1
                          ? Customer(
                              custId: '15dda9af-6527-02ba-ec06-f5e85dff7156',
                              name: 'Quick Order',
                              email: 'quick@order.com',
                              phoneNumber: '0000000000',
                              address: 'Quick Order Address',
                              createdAt: DateTime.now().toIso8601String(),
                            )
                          : null,
                    ),
                  ),
                );

                if (newOrder != null) {
                  setState(() {
                    orders.add(newOrder);
                  });
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Expanded order list to take more space
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                // Search bar
                _buildSearchBar(),
                // Tab Bar
                _buildTabBar(),
                // Optional filters for the selected tab
                _buildFilters(),
                // Tab views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderListView(_getRegularOrders()),
                      _buildQuickOrdersView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Add order button at bottom
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search orders...",
          prefixIcon: const Icon(Icons.search, color: Color(0xFF2f4757)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF2f4757)),
                  onPressed: () {
                    _searchController.clear();
                    _searchOrders();
                  },
                )
              : null,
        ),
        onChanged: (text) => _searchOrders(),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(
            width: 3.0,
            color: Color(0xFF2f4757),
          ),
          insets: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        labelColor: const Color(0xFF2f4757),
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Regular Orders'),
          Tab(text: 'Quick Orders'),
        ],
      ),
    );
  }

// Filters for Regular Orders
  Widget _buildFilters() {
    if (_currentTabIndex == 0) {
      return Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            _buildFilterTag('All'),
            _buildFilterTag('Recent'),
            _buildFilterTag('Old'),
            _buildFilterTag('Amount: Low to High'),
            _buildFilterTag('Amount: High to Low'),
            _buildFilterTag('Date: Oldest First'),
            _buildFilterTag('Date: Newest First'),
          ],
        ),
      );
    } else if (_currentTabIndex == 1) {
      // Filters for Quick Orders
      return Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            _buildQuickOrderFilterTag('All'),
            _buildQuickOrderFilterTag('Recent'),
            _buildQuickOrderFilterTag('Old'),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildOrderListView(List<Order> ordersToDisplay) {
    final displayOrders = _searchResults.isEmpty
        ? _getFilteredOrders(ordersToDisplay)
        : _searchResults
            .where((order) => ordersToDisplay.contains(order))
            .toList();

    return ListView.builder(
      itemCount: displayOrders.length,
      itemBuilder: (context, index) {
        final order = displayOrders[index];
        return GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    OrderDetailsPage(order: order),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: const Offset(0, 0),
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            )
          },
          child: _buildOrderCard(order, context),
        );
      },
    );
  }

// Similarly, define _buildQuickOrdersView() to display only quick orders
  Widget _buildQuickOrdersView() {
    final quickOrders = _getQuickOrders();
    return _buildOrderListView(quickOrders);
  }

  Widget _buildQuickOrderFilterTag(String label) {
    return GestureDetector(
      onTap: () {
        // Implement filter logic for quick orders if needed
        setState(() {
          _filterType = label; // Or manage a separate filter for quick orders
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: _filterType == label
              ? const Color(0xFF2f4757)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _filterType == label
                ? const Color(0xFF2f4757)
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: _filterType == label
              ? [
                  BoxShadow(
                    color: const Color(0xFF2f4757).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _filterType == label ? Colors.white : Colors.grey.shade700,
            fontWeight:
                _filterType == label ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  List<Order> _getRegularOrders() {
    return orders
        .where((order) => order.customerName != 'Quick Order')
        .toList();
  }

  List<Order> _getQuickOrders() {
    return orders
        .where((order) => order.customerName == 'Quick Order')
        .toList();
  }

  List<Order> _getFilteredOrders(List<Order> ordersToFilter) {
    if (_currentTabIndex == 1) return ordersToFilter;

    switch (_filterType) {
      case 'Recent':
        return ordersToFilter
            .where((order) => DateTime.parse(order.orderDate)
                .isAfter(DateTime.now().subtract(Duration(days: 7))))
            .toList();
      case 'Old':
        return ordersToFilter
            .where((order) => DateTime.parse(order.orderDate)
                .isBefore(DateTime.now().subtract(Duration(days: 7))))
            .toList();
      case 'Amount: Low to High':
        return List.from(ordersToFilter)
          ..sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
      case 'Amount: High to Low':
        return List.from(ordersToFilter)
          ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
      case 'Date: Oldest First':
        return List.from(ordersToFilter)
          ..sort((a, b) => DateTime.parse(a.orderDate)
              .compareTo(DateTime.parse(b.orderDate)));
      case 'Date: Newest First':
        return List.from(ordersToFilter)
          ..sort((a, b) => DateTime.parse(b.orderDate)
              .compareTo(DateTime.parse(a.orderDate)));
      default:
        return ordersToFilter;
    }
  }

  // Search orders
  void _searchOrders() {
    setState(() {
      _searchResults = _getFilteredOrders(_getRegularOrders())
          .where((order) =>
              order.customerName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              order.totalAmount.contains(_searchController.text) ||
              order.orderDate.toString().contains(_searchController.text))
          .toList();
    });
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      ref.watch(orderServiceProvider).when(
        data: (orderService) async {
          await orderService.deleteOrder(orderId);
          ref.invalidate(getOrdersProvider);
        },
        error: (error, stackTrace) {
          print('Error sending order: $error');
        },
        loading: () {
          print('Sending order...');
        },
      );
      
    } catch (e) {
      print('Error sending order: $e');
    }
  }

  // Enhanced Order Card design
  Widget _buildOrderCard(Order order, BuildContext context) {
    final isQuickOrder = order.customerName == 'Quick Order';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.services.isNotEmpty
                              ? order.services.first['sname'] as String
                              : '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2f4757),
                          ),
                        ),
                        if (order.services.length > 1)
                          Text(
                            ' and ${order.services.length - 1} more',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2f4757),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!isQuickOrder) ...[
                      Text(
                        order.customerName,
                        style: const TextStyle(
                          color: Color(0xFF028F83),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (order.products.isNotEmpty)
                        Text(
                          'Products: ${order.products.length}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF028F83).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Quick Order',
                          style: TextStyle(
                            color: Color(0xFF028F83),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${order.totalAmount}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRightDouble,
                      color: Color(0xFF2f4757),
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  OrderDetailsPage(order: order),
                          transitionDuration: const Duration(milliseconds: 300),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const HugeIcon(
                      icon: Icons.delete_forever,
                      color: Colors.red,
                      size: 24.0,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Order'),
                          content: Text(
                            'Are you sure you want to delete ${isQuickOrder ? 'this Quick Order' : '${order.customerName}\'s order'}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await deleteOrder(order.orderId);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Filter Tag design
  Widget _buildFilterTag(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: _filterType == label
              ? const Color(0xFF2f4757)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _filterType == label
                ? const Color(0xFF2f4757)
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: _filterType == label
              ? [
                  BoxShadow(
                    color: const Color(0xFF2f4757).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _filterType == label ? Colors.white : Colors.grey.shade700,
            fontWeight:
                _filterType == label ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
