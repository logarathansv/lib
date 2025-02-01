import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/service_demand.dart';

// ServiceDemandBarChart widget to display the bar chart
class ServiceDemandBarChart extends StatelessWidget {
  final List<ServiceDemand> serviceData;

  // Constructor to receive the service data
  const ServiceDemandBarChart({
    super.key,
    required this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    // Extract unique service names for the x-axis labels
    final List<String> serviceNames = serviceData
        .map((service) => service.serviceName)
        .toSet()
        .toList(); // Remove duplicates

    // Preparing to hold bar chart data
    List<BarChartGroupData> barChartData = [];

    // Create a map to aggregate demand values for each service per month
    Map<String, Map<int, int>> groupedData = {};
    for (var service in serviceData) {
      if (!groupedData.containsKey(service.serviceName)) {
        groupedData[service.serviceName] = {};
      }
      groupedData[service.serviceName]![service.month] = service.demand;
    }

    // Prepare bar chart data
    serviceNames.asMap().forEach((index, serviceName) {
      // Initialize demand for all months
      int totalDemand = 0;
      for (int month = 1; month <= 12; month++) {
        int demand = groupedData[serviceName]?[month] ?? 0; // Default to 0
        totalDemand +=
            demand; // Accumulate total demand for accurate representation
      }
      barChartData.add(
        BarChartGroupData(
          x: index, // Use the index in the list for x-axis
          barRods: [
            BarChartRodData(
              toY: totalDemand.toDouble(), // Total demand value
              color: Colors.blue, // Customize color if needed
              width: 15,
            ),
          ],
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Service Comparison', // Title of the chart
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16), // Space between the title and the chart
          AspectRatio(
            aspectRatio: 1.5, // Aspect ratio to make it responsive
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment
                    .spaceAround, // Space the bars appropriately
                barGroups: barChartData,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // Reserved space for bottom titles
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt(); // Get the x-axis index
                        if (index >= 0 && index < serviceNames.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              serviceNames[index], // Provide relevant labels
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }
                        return Container(); // Empty widget if index is out of range
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false), // Remove grid lines
              ),
            ),
          ),
        ],
      ),
    );
  }
}
