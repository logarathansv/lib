import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomerAnalyticsPage extends StatefulWidget {
  const CustomerAnalyticsPage({super.key});

  @override
  _CustomerAnalyticsPageState createState() => _CustomerAnalyticsPageState();
}

class _CustomerAnalyticsPageState extends State<CustomerAnalyticsPage> {
  bool _showAllCustomers = false; // Track whether to show all customers or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Customer Analytics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCustomerPieChart(),
            buildHighValueCustomers(),
            buildInactiveCustomers(),
          ],
        ),
      ),
    );
  }

  // Displays a pie chart for new and old customers
  Widget buildCustomerPieChart() {
    const int newCustomers = 40;
    const int oldCustomers = 60;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Segmentation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: newCustomers.toDouble(),
                      title: '$newCustomers%',
                      color: Colors.green,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: oldCustomers.toDouble(),
                      title: '$oldCustomers%',
                      color: Colors.blue,
                      radius: 60,
                    ),
                  ],
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('New Customers: $newCustomers%',
                style: const TextStyle(color: Colors.green)),
            Text('Old Customers: $oldCustomers%',
                style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  // Displays the high-value customers
  Widget buildHighValueCustomers() {
    final List<Customer> highValueCustomers = [
      Customer(name: 'Alice', value: 1200),
      Customer(name: 'Bob', value: 1100),
      Customer(name: 'Carol', value: 1000),
      Customer(name: 'David', value: 950),
      Customer(name: 'Eve', value: 900),
      Customer(name: 'Frank', value: 850),
    ];

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'High-Value Customers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Show top 3 customers always
            for (int i = 0;
                i < (_showAllCustomers ? highValueCustomers.length : 3);
                i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, //Aligns items on both ends
                    children: [
                      Text(highValueCustomers[i].name),
                      Text('\$${highValueCustomers[i].value}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            // Arrow button to toggle expanded view
            TextButton(
              onPressed: () {
                setState(() {
                  _showAllCustomers = !_showAllCustomers;
                });
              },
              child: Text(
                _showAllCustomers ? 'Show Less' : 'Show More',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Displays inactive customers and a notify button
  Widget buildInactiveCustomers() {
    final List<String> inactiveCustomers = ['George', 'Hannah', 'Isaac'];

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inactive Customers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...inactiveCustomers.map((customer) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(customer),
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Notify action here
                print('Notify inactive customers pressed');
              },
              child: const Text('Notify Inactive Customers'),
            ),
          ],
        ),
      ),
    );
  }
}

class Customer {
  final String name;
  final int value;

  Customer({required this.name, required this.value});
}
