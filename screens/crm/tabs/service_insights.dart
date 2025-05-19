import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/models/crm_model/service_insights/service_crm_models.dart';
import 'package:sklyit_business/providers/crm/service_insights_provider.dart';
import 'package:shimmer/shimmer.dart';

class ServiceInsightsPage extends ConsumerStatefulWidget {
  const ServiceInsightsPage({super.key});

  @override
  ConsumerState<ServiceInsightsPage> createState() => _ServiceInsightsPageState();
}

class _ServiceInsightsPageState extends ConsumerState<ServiceInsightsPage> {
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
            buildAreasToImprove(),
            buildTopEarningServices(),
            buildServiceTrends(trendData),
          ],
        ),
      ),
    );
  }

  Widget buildTopServices() {
    final topServicesAsync = ref.watch(getTopServicesByBookings);

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
            topServicesAsync.when(
              data: (data) { 
                if (data.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No Services found.', style: TextStyle(color: Colors.grey)),
                  );
                };
                return Column(
                children: data.map((service) => ListTile(
                  title: Text(service.serviceName),
                  trailing: Text('${service.bookings} Bookings'),
                )).toList(),
              );
              },
              loading: () => Column(
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListTile(
                      title: Container(height: 16, width: 100, color: Colors.grey[300]),
                      trailing: Container(height: 16, width: 60, color: Colors.grey[300]),
                    ),
                  ),
                )),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Failed to load top services', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAreasToImprove() {
    final bottomServicesAsync = ref.watch(getBottomServicesByBookings);
  
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Areas to Improve',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            bottomServicesAsync.when(
              data: (leastUsed) { 
                if (leastUsed.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No Bookings found.', style: TextStyle(color: Colors.grey)),
                  );
                };
                return Column(
                children: leastUsed.map((service) => Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListTile(
                    title: Text(service.serviceName),
                    trailing: Text('Bookings: ${service.bookings}'),
                  ),
                )).toList(),
              );
              },
              loading: () => Column(
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListTile(
                      title: Container(height: 16, width: 100, color: Colors.grey[300]),
                      trailing: Container(height: 16, width: 60, color: Colors.grey[300]),
                    ),
                  ),
                )),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Failed to load areas to improve', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopEarningServices() {
    final revenueDataAsync = ref.watch(getTopServicesByRevenue);
  
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Top Earning Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            revenueDataAsync.when(
              data: (revenueData) { 
                if (revenueData.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No Data found.', style: TextStyle(color: Colors.grey)),
                  );
                };
                return Column(
                children: revenueData.map((data) => ListTile(
                  title: Text(data.service),
                  trailing: Text('${data.revenue}'),
                )).toList(),
              );
              },
              loading: () => Column(
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListTile(
                      title: Container(height: 16, width: 100, color: Colors.grey[300]),
                      trailing: Container(height: 16, width: 60, color: Colors.grey[300]),
                    ),
                  ),
                )),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Failed to load top earning services', style: TextStyle(color: Colors.red)),
              ),
            ),
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