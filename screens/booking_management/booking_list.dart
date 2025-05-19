import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/providers/booking_provider.dart';

import '../../models/booking_model/bookings.dart';
import '../../widgets/booking_card.dart';
import 'booking_details.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _oldRequestTabController;
  String _searchQuery = "";
  int _oldRequestTabIndex = 0; // For old requests filter

  final List<String> oldRequestStatuses = [
    "Accepted",
    "Rejected",
    "Cancelled",
    "Completed"
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _oldRequestTabController = TabController(length: oldRequestStatuses.length, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _oldRequestTabController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft03,
              color: Colors.black87,
              size: 24.0,
            ),
          ),
        ),
        title: const Text(
          'Bookings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2f4757),
            letterSpacing: 0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            height: 4.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: _updateSearchQuery,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search bookings...",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Main Tabs: New Requests & Old Requests
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _mainTabController,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: const Color(0xfff4c345),
                  labelColor: const Color(0xFF2f4757),
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: "New Requests"),
                    Tab(text: "Old Requests"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _mainTabController,
                  children: [
                    // New Requests Tab
                    BookingList(
                      bookingType: "Pending",
                      searchQuery: _searchQuery,
                      showStatusSymbol: true,
                    ),
                    // Old Requests Tab with filter
                    Column(
                      children: [
                        // Old Requests Filter Tabs
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TabBar(
                            controller: _oldRequestTabController,
                            isScrollable: true,
                            indicatorColor: const Color(0xfff4c345),
                            labelColor: const Color(0xFF2f4757),
                            unselectedLabelColor: Colors.grey[600],
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            onTap: (index) {
                              setState(() {
                                _oldRequestTabIndex = index;
                              });
                            },
                            tabs: oldRequestStatuses
                                .map((status) => Tab(text: status))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: BookingList(
                            bookingType: oldRequestStatuses[_oldRequestTabIndex],
                            searchQuery: _searchQuery,
                            showStatusSymbol: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BookingList now takes showStatusSymbol
class BookingList extends ConsumerWidget {
  final String bookingType;
  final String searchQuery;
  final bool showStatusSymbol;

  BookingList({
    super.key,
    required this.bookingType,
    required this.searchQuery,
    this.showStatusSymbol = false,
  });

  Color _statusColor(String status) {
    switch (status) {
      case "Accepted":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Cancelled":
        return Colors.orange;
      case "Completed":
        return Colors.blue;
      case "Pending":
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "Accepted":
        return Icons.check_circle;
      case "Rejected":
        return Icons.cancel;
      case "Cancelled":
        return Icons.remove_circle;
      case "Completed":
        return Icons.verified;
      case "Pending":
        return Icons.hourglass_top;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingasync = ref.watch(getbookingProvider);

    return bookingasync.when(
      data: (bookings) {
        List<Booking> filteredBookings = bookings.where((booking) {
          bool matchesType = booking.status == bookingType;
          bool matchesSearch = searchQuery.isEmpty ||
              booking.customerName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              booking.service['ServiceName'].toString().toLowerCase().contains(searchQuery.toLowerCase());
          return matchesType && matchesSearch;
        }).toList();

        return ListView(
          children: [
            for (var booking in filteredBookings)
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (bookingType != 'Accepted')
                              ? BookingDetailsPage(
                                  customerName: booking.customerName,
                                  services: [booking.service['ServiceName'] as String],
                                  date: booking.date,
                                  time: booking.time,
                                  serviceMode: booking.serviceMode,
                                  status: booking.status,
                                )
                              : BookingDetailsPage(
                                  bookingId: booking.BookingId,
                                  customerName: booking.customerName,
                                  customerId: booking.customerId,
                                  services: [booking.service['ServiceName'] as String],
                                  date: booking.date,
                                  time: booking.time,
                                  serviceMode: booking.serviceMode,
                                  addressCity: booking.addressCity,
                                  addressStreet: booking.addressStreet,
                                  addressDoorno: booking.addressDoorno,
                                  addressPincode: booking.addressPincode,
                                  customerPhone: booking.customerPhone,
                                  status: booking.status,
                                ))),
                },
                child: Stack(
                  children: [
                    BookingCard(
                      booking: booking,
                    ),
                    if (showStatusSymbol)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          _statusIcon(booking.status),
                          color: _statusColor(booking.status),
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
      error: (error, _) => Text('Error: $error'),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}