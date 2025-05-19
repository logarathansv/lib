import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/providers/crm/dashboard_insights_provider.dart';

class RetentionCard extends ConsumerWidget {
  const RetentionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getRetentionAsync = ref.watch(getRetentionRate);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: getRetentionAsync.when(
          data: (retentionRate) {
            if (retentionRate.retentionRate == 0 && retentionRate.churnRate == 0) {
              return const Text('No retention data available.', style: TextStyle(color: Colors.grey));
            }
            final double churnRate = retentionRate.churnRate;
            return Column(
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
                          value: retentionRate.retentionRate,
                          color: const Color(0xfff4c345),
                          title: '${retentionRate.retentionRate.toStringAsFixed(1)}%',
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: churnRate,
                          color: const Color(0xFF028F83),
                          title: '${churnRate.toStringAsFixed(1)}%',
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
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
                        Container(width: 16, height: 16, color: const Color(0xfff4c345)),
                        const SizedBox(width: 8),
                        Text("Retention (${retentionRate.retentionRate.toStringAsFixed(1)}%)"),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 16, height: 16, color: const Color(0xFF028F83)),
                        const SizedBox(width: 8),
                        Text("Churned (${churnRate.toStringAsFixed(1)}%)"),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Failed to load retention rate', style: TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
