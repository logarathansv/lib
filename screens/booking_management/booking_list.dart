import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../models/booking_model/bookings.dart';
import '../../widgets/booking_card.dart';
import 'booking_details.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          'Bookings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search... ",
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tabs for New Requests, Rejected, and Cancelled
            TabBar(
              controller: _tabController,
              labelPadding: const EdgeInsets.symmetric(horizontal: 10),
              indicatorColor: const Color(0xfff4c345),
              labelColor: const Color(0xFF2f4757), // Selected label color
              unselectedLabelColor:
                  const Color(0xFF2f4757), // Unselected label color
              tabs: const [
                Tab(
                  text: "New Requests", // Full text shown
                ),
                Tab(
                  text: "Rejected", // Full text shown
                ),
                Tab(
                  text: "Cancelled", // Full text shown
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BookingList(bookingType: "New Requests"),
                  BookingList(bookingType: "Rejected"),
                  BookingList(bookingType: "Cancelled"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final String bookingType;
  final List<Booking> bookings = [
    Booking(
      customerName: 'John Doe',
      services: ['Plumbing'],
      date: '2023-02-20',
      time: '09:00',
      serviceMode: 'At Home',
      isNewCustomer: true,
      address: '123 Main St, City',
    ),
    Booking(
      customerName: 'Jane Smith',
      services: ['Electrical'],
      date: '2023-03-15',
      time: '14:30',
      serviceMode: 'Online',
      isNewCustomer: false,
      address: '456 Elm St, Town',
    ),
    Booking(
      customerName: 'Bob Johnson',
      services: ['Painting'],
      date: '2023-04-10',
      time: '16:45',
      serviceMode: 'At Home',
      isNewCustomer: true,
      address: '789 Oak St, Village',
    )
  ];
  BookingList({super.key, required this.bookingType});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Sample booking data for demonstration
        for (var i = 0; i <= 3; i++)
          GestureDetector(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsPage(
                        customerName: bookings[i].customerName,
                        services: bookings[i].services,
                        date: bookings[i].date,
                        time: bookings[i].time,
                        serviceMode: bookings[i].serviceMode,
                        isNewCustomer: bookings[i].isNewCustomer,
                        address: bookings[i].address),
                  ))
            },
            child: BookingCard(
              customerName: "Customer $i",
              services: "Service ${i == 1 ? "A" : (i == 2 ? "B" : "C")}",
              date: "2023-10-${i + 1}",
              time: "10:0$i AM",
              bookingType: bookingType,
            ),
          ),
      ],
    );
  }
}
