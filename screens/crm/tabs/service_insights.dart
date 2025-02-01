import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ServiceInsightsPage extends StatefulWidget {
  const ServiceInsightsPage({super.key});

  @override
  State<ServiceInsightsPage> createState() => _ServiceInsightsPageState();
}

class _ServiceInsightsPageState extends State<ServiceInsightsPage> {
  String _view = 'Weekly';
  // Default view is weekly
  final List<TrendData> _weeklyData = [
    TrendData(year: 'Mon', bookings: 100),
    TrendData(year: 'Tue', bookings: 200),
    TrendData(year: 'Wed', bookings: 300),
  ];

  final List<TrendData> _monthlyData = [
    TrendData(year: 'Jan', bookings: 800),
    TrendData(year: 'Feb', bookings: 600),
    TrendData(year: 'Mar', bookings: 400),
  ];

  final List<TrendData> _yearlyData = [
    TrendData(year: '2021', bookings: 1000),
    TrendData(year: '2022', bookings: 1500),
    TrendData(year: '2023', bookings: 2000),
  ];

  @override
  Widget build(BuildContext context) {
    List<TrendData> trendData;

    switch (_view) {
      case 'Monthly':
        trendData = _monthlyData;
        break;
      case 'Yearly':
        trendData = _yearlyData;
        break;
      default:
        trendData = _weeklyData;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Service Insights'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTopServices(),
            buildUsageStats(),
            buildRevenueStats(),
            buildServiceTrends(trendData),
          ],
        ),
      ),
    );
  }

  Widget buildTopServices() {
    // Sample Data for Top Services
    final List<ServiceData> data = [
      ServiceData(serviceName: 'Facial', bookings: 150),
      ServiceData(serviceName: 'Massage', bookings: 120),
      ServiceData(serviceName: 'Haircut', bookings: 100),
    ];

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Top 3 Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...data.map((service) => ListTile(
                  title: Text(service.serviceName),
                  trailing: Text('${service.bookings} Bookings'),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildUsageStats() {
    // Sample Data for Most Used and Least Used Services
    final List<ServiceData> mostUsed = [
      ServiceData(serviceName: 'Facial', bookings: 150),
      ServiceData(serviceName: 'Massage', bookings: 120),
      ServiceData(serviceName: 'Haircut', bookings: 100),
    ];

    final List<LeastUsedService> leastUsed = [
      LeastUsedService(
          serviceName: 'Nail Art',
          bookings: 20,
          areaToImprove: 'Increase marketing and visibility'),
      LeastUsedService(
          serviceName: 'Makeup',
          bookings: 15,
          areaToImprove: 'Provide promotional discounts'),
    ];

    // Create BarChartGroupData for Most Used
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < mostUsed.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: mostUsed[i].bookings.toDouble(),
              color: Colors.blue,
              width: 15,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 3 Most Used Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Increase space for the left titles
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38, // Space for the bottom titles
                        getTitlesWidget: (value, meta) {
                          // Make sure to handle index-based service names
                          return Text(
                            mostUsed[value.toInt()].serviceName,
                            style: const TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false)), // Disable top titles
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false)), // Disable right titles
                  ),
                  borderData: FlBorderData(show: false), // No border
                  gridData: const FlGridData(show: true), // Show grid lines
                  barTouchData: BarTouchData(
                      enabled: false), // Disable touch interactions
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Areas to Improve',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...leastUsed.map((service) => Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListTile(
                    title: Text(service.serviceName),
                    subtitle: Text('Bookings: ${service.bookings}'),
                    trailing: Text(service.areaToImprove),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildRevenueStats() {
    // Sample Data for Top Earning Services
    final List<ServiceRevenueData> revenueData = [
      ServiceRevenueData(service: 'Facial', revenue: 3000),
      ServiceRevenueData(service: 'Massage', revenue: 2400),
      ServiceRevenueData(service: 'Haircut', revenue: 1800),
    ];

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Top Earning Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...revenueData.map((data) => ListTile(
                  title: Text(data.service),
                  trailing: Text('\$${data.revenue}'),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildServiceTrends(List<TrendData> trendData) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Service Trends Over Time',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      switch (_view) {
                        case 'Weekly':
                          _view = 'Monthly';
                          break;
                        case 'Monthly':
                          _view = 'Yearly';
                          break;
                        case 'Yearly':
                          _view = 'Weekly';
                          break;
                      }
                    });
                  },
                ),
              ],
            ),
            // Display the selected time period (Weekly, Monthly, or Yearly)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'View: $_view',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 250, // Increased height for better visualization
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize:
                            40, // Increased reserved size to avoid overlap
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(),
                              style: const TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();

                          // Handle time periods and ensure single label per data point
                          if (_view == 'Weekly') {
                            // Show 'Week X'
                            return Text('W${index + 1}');
                          } else if (_view == 'Monthly') {
                            // Show Month names
                            const months = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                              'Jul',
                              'Aug',
                              'Sep',
                              'Oct',
                              'Nov',
                              'Dec'
                            ];
                            if (index < months.length) {
                              return Text(months[index]);
                            }
                          } else if (_view == 'Yearly') {
                            // Show Yearly labels
                            return Text('Year ${index + 2020}');
                          }
                          return Container(); // Default case
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false)), // Remove top axis labels
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false)), // Remove right axis labels
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: trendData.length.toDouble() - 1,
                  minY: 0,
                  maxY: trendData
                          .map((e) => e.bookings.toDouble())
                          .reduce((a, b) => a > b ? a : b) +
                      100, // Ensure y-axis has a consistent scale
                  lineBarsData: [
                    LineChartBarData(
                      spots: trendData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                              e.key.toDouble(), e.value.bookings.toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceData {
  final String serviceName;
  final int bookings;

  ServiceData({required this.serviceName, required this.bookings});
}

class ServiceRevenueData {
  final String service;
  final int revenue;

  ServiceRevenueData({required this.service, required this.revenue});
}

class TrendData {
  final String year;
  final int bookings;

  TrendData({required this.year, required this.bookings});
}

class LeastUsedService {
  final String serviceName;
  final int bookings;
  final String areaToImprove;

  LeastUsedService(
      {required this.serviceName,
      required this.bookings,
      required this.areaToImprove});
}
