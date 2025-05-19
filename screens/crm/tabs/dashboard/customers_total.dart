import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/providers/crm/dashboard_insights_provider.dart';

class CustomerGraph extends ConsumerStatefulWidget {
  const CustomerGraph({super.key});

  @override
  _CustomerGraphState createState() => _CustomerGraphState();
}

class _CustomerGraphState extends ConsumerState<CustomerGraph> {
  bool isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final title = isWeekly ? "Weekly Customers" : "Monthly Customers";
    final weeklyAsync = ref.watch(getWeeklyCustomerData);
    final monthlyAsync = ref.watch(getMonthlyCustomerData);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(isWeekly ? Icons.arrow_forward : Icons.arrow_back),
                  onPressed: () {
                    setState(() => isWeekly = !isWeekly);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Data Loading
            isWeekly
                ? weeklyAsync.when(
                    data: (data) => _buildBarChart(
                      data.map((e) => e.customerCount.toDouble()).toList(),
                      data.map((e) => 'W${data.indexOf(e) + 1}').toList(),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  )
                : monthlyAsync.when(
                    data: (data) {
                      final last4Months = data.length > 4
                          ? data.sublist(data.length - 4)
                          : data;
                      return _buildBarChart(
                        last4Months
                            .map((e) => e.customerCount.toDouble())
                            .toList(),
                        last4Months
                            .map((e) => _monthLabel(e.monthStart))
                            .toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  ),
          ],
        ),
      ),
    );
  }
}
Widget _buildBarChart(List<double> values, List<String> labels) {
  if (values.isEmpty) {
    return const Center(child: Text('No data available'));
  }

  return AspectRatio(
    aspectRatio: 1.7,
    child: BarChart(
      BarChartData(
        barGroups: List.generate(values.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(toY: values[i], color: Colors.blue, width: 20),
            ],
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int index = value.toInt();
                if (index < labels.length) {
                  return Text(labels[index], style: const TextStyle(color: Colors.black));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                return Text(value.toInt().toString(), style: const TextStyle(color: Colors.black));
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black26)),
      ),
    ),
  );
}
String _monthLabel(DateTime date) {
  return _monthNames[date.month - 1];
}

const List<String> _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];
