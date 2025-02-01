import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RetentionCard extends StatelessWidget {
  final double retentionRate;

  const RetentionCard({
    super.key,
    required this.retentionRate,
  });

  @override
  Widget build(BuildContext context) {
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
              "Retention Rate",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Pie Chart
            AspectRatio(
              aspectRatio: 1.5,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: retentionRate,
                      color: const Color(0xfff4c345),
                      title: '${retentionRate.toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 100 - retentionRate,
                      color: const Color(0xFF028F83),
                      title: '${(100 - retentionRate).toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 4, // Adds space between sections
                  centerSpaceRadius:
                      40, // Empty center for a realistic doughnut effect
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Color Code Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                        width: 16, height: 16, color: const Color(0xfff4c345)),
                    const SizedBox(width: 8),
                    Text("Retention (${retentionRate.toStringAsFixed(1)}%)"),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 16, height: 16, color: const Color(0xFF028F83)),
                    const SizedBox(width: 8),
                    Text(
                        "Churned (${(100 - retentionRate).toStringAsFixed(1)}%)"),
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
