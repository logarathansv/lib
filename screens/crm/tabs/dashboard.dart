import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../models/crm_model/dashboard/customers_total.dart';
import '../../../models/crm_model/dashboard/growth_rate.dart';
import '../../../models/crm_model/dashboard/retention_rate.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String filter = "Monthly"; // Default filter
  List<double> customersData = [300, 200, 400, 600]; // Mock data for customers
  List<double> growthData = [5, 15, 20, 10]; // Mock growth rate data
  double retentionRate = 80; // Mock retention rate
  double totalRevenue = 1000; // Mock total revenue
  double profit = 200; // Mock profit
  double loss = 50; // Mock loss

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomerGraph(),
              GrowthRateGraph(),
              const RetentionCard(
                retentionRate: 50.0,
              ),
              _buildRevenueCard(1000, 20),
              const SizedBox(height: 20), // Spacing
              _buildDataTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
                height: 200, child: child), // Fix height to ensure uniformity
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard(double profit, double profitPercentage) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Revenue",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profit: \$${profit.toStringAsFixed(2)} (${profitPercentage.toStringAsFixed(1)}%)",
                      style: const TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.green),
                        SizedBox(width: 5),
                        Text(
                          "Revenue is on the rise",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.attach_money,
                    size: 50, color: Color(0xff036c7b)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Additional Data",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DataTable(columns: const [
              DataColumn(
                  label: Text('Metric',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Value',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ], rows: const [
              DataRow(cells: [
                DataCell(Text('Total Customers')),
                DataCell(Text('1000')),
              ]),
              DataRow(cells: [
                DataCell(Text('Growth Rate')),
                DataCell(Text('15%')),
              ]),
              DataRow(cells: [
                DataCell(Text('Retention Rate')),
                DataCell(Text('80%')),
              ]),
              DataRow(cells: [
                DataCell(Text('Churn Rate')),
                DataCell(Text('20%')),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}
