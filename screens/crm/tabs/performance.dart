import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../models/service_demand.dart';
import '../../../utils/service_demand_bar_chart.dart';

class PerformanceComparison extends StatefulWidget {
  const PerformanceComparison({super.key});

  @override
  _PerformanceComparisonState createState() => _PerformanceComparisonState();
}

class _PerformanceComparisonState extends State<PerformanceComparison> {
  // Sample data for the last 6 months
  final List<Map<String, dynamic>> monthlyData = [
    {
      'month': 'July',
      'totalCustomers': 150,
      'newCustomers': 50,
      'revenue': 2000,
    },
    {
      'month': 'August',
      'totalCustomers': 160,
      'newCustomers': 60,
      'revenue': 2100,
    },
    {
      'month': 'September',
      'totalCustomers': 170,
      'newCustomers': 70,
      'revenue': 2200,
    },
    {
      'month': 'October',
      'totalCustomers': 180,
      'newCustomers': 80,
      'revenue': 2400,
    },
    {
      'month': 'November',
      'totalCustomers': 190,
      'newCustomers': 90,
      'revenue': 2500,
    },
    {
      'month': 'December',
      'totalCustomers': 200,
      'newCustomers': 100,
      'revenue': 2600,
    },
  ];

  // To hold the selected month index, starting with December (index 5)
  int _selectedMonthIndex = 5;

  // Service demand data
  List<ServiceDemand> serviceData = [];

  @override
  void initState() {
    super.initState();
    _updateServiceData(); // Initialize the service data with the selected month
  }

  // Update service demand data based on the selected month
  void _updateServiceData() {
    final monthData = monthlyData[_selectedMonthIndex];
    setState(() {
      serviceData = [
        ServiceDemand(
            serviceName: 'Service A',
            month: _selectedMonthIndex,
            demand: monthData['newCustomers'] * 2), // Example logic for demand
        ServiceDemand(
            serviceName: 'Service B',
            month: _selectedMonthIndex,
            demand: monthData['totalCustomers'] - monthData['newCustomers']),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Performance Comparison'),
      ),
      body: ListView(
        children: [
          _buildMonthlyComparison(),
          _buildPieChart(),
          const SizedBox(height: 40),
          ServiceDemandBarChart(
              serviceData:
                  serviceData), // Bar chart will update when the serviceData changes
        ],
      ),
    );
  }

  // Monthly Comparison Section
  Widget _buildMonthlyComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Monthly Comparison',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )),
        // Arrow buttons to navigate between months
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: _selectedMonthIndex > 0
                    ? () {
                        setState(() {
                          _selectedMonthIndex--;
                          _updateServiceData(); // Update service data when month changes
                        });
                      }
                    : null,
              ),
              Text(
                monthlyData[_selectedMonthIndex]['month'],
                style: const TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: _selectedMonthIndex < monthlyData.length - 1
                    ? () {
                        setState(() {
                          _selectedMonthIndex++;
                          _updateServiceData(); // Update service data when month changes
                        });
                      }
                    : null,
              ),
            ],
          ),
        ),
        // Month label and data display
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataRow(
                      Icons.people,
                      'Total Customers',
                      monthlyData[_selectedMonthIndex]['totalCustomers']
                          .toString()),
                  _buildDataRow(
                      Icons.person_add,
                      'New Customers',
                      monthlyData[_selectedMonthIndex]['newCustomers']
                          .toString()),
                  _buildDataRow(Icons.monetization_on_outlined, 'Revenue',
                      '\$${monthlyData[_selectedMonthIndex]['revenue']}'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: Colors.blue, size: 24), // Icon next to the title
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Pie Chart for Monthly Comparison
  Widget _buildPieChart() {
    final monthData = monthlyData[_selectedMonthIndex];
    final totalCustomers = monthData['totalCustomers'];
    final newCustomers = monthData['newCustomers'];
    final oldCustomers = totalCustomers - newCustomers;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200, // Set a specific height to ensure the chart is rendered
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: newCustomers.toDouble(),
                color: Colors.blue,
                title: 'New: $newCustomers',
                radius: 50,
                titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              PieChartSectionData(
                value: oldCustomers.toDouble(),
                color: Colors.orange,
                title: 'Old: $oldCustomers',
                radius: 50,
                titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 40,
            sectionsSpace: 2, // Space between pie chart sections
          ),
        ),
      ),
    );
  }
}
