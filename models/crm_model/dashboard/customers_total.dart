import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomerGraph extends StatefulWidget {
  const CustomerGraph({super.key});

  @override
  _CustomerGraphState createState() => _CustomerGraphState();
}

class _CustomerGraphState extends State<CustomerGraph> {
  bool isWeekly = true;

  final weeklyData = [10.0, 20.0, 30.0, 40.0]; // Weekly data
  final monthlyData = [50.0, 60.0, 70.0, 80.0]; // Monthly data

  @override
  Widget build(BuildContext context) {
    final currentData = isWeekly ? weeklyData : monthlyData;
    final title = isWeekly ? "Weekly Customers" : "Monthly Customers";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      isWeekly = !isWeekly; // Toggle graph
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(
                    currentData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: currentData[index],
                          color: Colors.blue,
                          width: 20,
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
                      sideTitles: SideTitles(showTitles: false),
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
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true), // Optional grid lines
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
