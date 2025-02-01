import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenueInsightsPage extends StatefulWidget {
  const RevenueInsightsPage({super.key});

  @override
  _RevenueInsightsPageState createState() => _RevenueInsightsPageState();
}

class _RevenueInsightsPageState extends State<RevenueInsightsPage> {
  // Index for time period: 0 = Weekly, 1 = Monthly, 2 = Yearly
  int selectedPeriodIndex = 0;

  // Data for services (top 3 services and others)
  final List<String> services = [
    "Service 1",
    "Service 2",
    "Service 3",
    "Others"
  ];
  final List<List<double>> revenueData = [
    [5000.0, 4000.0, 3000.0, 1500.0], // Weekly data
    [20000.0, 18000.0, 15000.0, 8000.0], // Monthly data
    [50000.0, 45000.0, 40000.0, 20000.0], // Yearly data
  ];

  @override
  Widget build(BuildContext context) {
    // Get the revenue data based on the selected period (weekly, monthly, yearly)
    final currentRevenueData = revenueData[selectedPeriodIndex];

    // Title for the graph based on selected period
    final title = selectedPeriodIndex == 0
        ? "Weekly Insights"
        : selectedPeriodIndex == 1
            ? "Monthly Insights"
            : "Yearly Insights";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Revenue Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title and Slider for selecting period
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    selectedPeriodIndex == 0
                        ? Icons.arrow_forward
                        : selectedPeriodIndex == 1
                            ? Icons.arrow_back
                            : Icons.refresh,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle between weekly, monthly, and yearly
                      selectedPeriodIndex = (selectedPeriodIndex + 1) % 3;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bar Chart
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: currentRevenueData.reduce((a, b) => a > b ? a : b) +
                      1000, // Scale Y-axis
                  barGroups: List.generate(
                    currentRevenueData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: currentRevenueData[index],
                          color: index == currentRevenueData.length - 1
                              ? Colors.grey // Color for 'Others' bar
                              : Colors.blue, // Color for individual services
                          width: 30,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < services.length) {
                            return Text(
                              services[index],
                              style: const TextStyle(color: Colors.black),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize:
                            50, // Increase reserved size for better spacing
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false)), // No top titles
                    rightTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false)), // No right titles
                  ),
                  gridData: const FlGridData(show: true), // Optional grid lines
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: Colors.black26), // Optional border
                  ),
                ),
              ),
            ),
            const Text(
              'Contribution of New and Old Customers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Row for displaying percentages in a larger font
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '60%',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'New Customers',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 40), // Space between the two columns
                Column(
                  children: [
                    Text(
                      '40%',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Old Revenue',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
