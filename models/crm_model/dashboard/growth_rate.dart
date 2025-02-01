import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrowthRateGraph extends StatefulWidget {
  const GrowthRateGraph({super.key});

  @override
  _GrowthRateGraphState createState() => _GrowthRateGraphState();
}

class _GrowthRateGraphState extends State<GrowthRateGraph> {
  bool isWeekly = true;

  final weeklyData = [10.0, 20.0, 30.0, 40.0]; // Weekly data
  final monthlyData = [50.0, 60.0, 70.0, 80.0]; // Monthly data

  @override
  Widget build(BuildContext context) {
    final currentData = isWeekly ? weeklyData : monthlyData;
    final title = isWeekly ? "Weekly Growth Rate" : "Monthly Growth Rate";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Toggle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(isWeekly ? Icons.arrow_forward : Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      isWeekly = !isWeekly; // Toggle between weekly and monthly
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Line Chart
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        currentData.length,
                        (index) => FlSpot(index.toDouble(), currentData[index]),
                      ),
                      isCurved: true, // Smooth lines
                      color: Colors.green,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true), // Show dots
                      belowBarData: BarAreaData(show: false), // No shading
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text(isWeekly ? 'W1' : 'M1',
                                  style: const TextStyle(color: Colors.black));
                            case 1:
                              return Text(isWeekly ? 'W2' : 'M2',
                                  style: const TextStyle(color: Colors.black));
                            case 2:
                              return Text(isWeekly ? 'W3' : 'M3',
                                  style: const TextStyle(color: Colors.black));
                            case 3:
                              return Text(isWeekly ? 'W4' : 'M4',
                                  style: const TextStyle(color: Colors.black));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false), // Disable top X-axis titles
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false), // Disable right Y-axis titles
                    ),
                  ),
                  gridData: const FlGridData(show: true), // Optional grid lines
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: Colors.black26), // Optional border
                  ),
                  minY: 0, // Adjust based on data
                  maxY: (currentData.reduce((a, b) => a > b ? a : b)) +
                      10, // Scale Y-axis
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
