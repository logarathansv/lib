import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sklyit_business/models/crm_model/customer_analytics/customer_analytics_model.dart';
import 'package:sklyit_business/providers/crm/customer_analytics.dart';
import 'package:shimmer/shimmer.dart';

class CustomerAnalyticsPage extends ConsumerStatefulWidget {
  const CustomerAnalyticsPage({super.key});

  @override
  _CustomerAnalyticsPageState createState() => _CustomerAnalyticsPageState();
}

class _CustomerAnalyticsPageState extends ConsumerState<CustomerAnalyticsPage> {
  bool _showAllCustomers = false; // Track whether to show all customers or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Customer Analytics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCustomerPieChart(),
            buildHighValueCustomers(),
            buildInactiveCustomers(),
          ],
        ),
      ),
    );
  }

  // Displays a pie chart for new and old customers
  Widget buildCustomerPieChart() {
    final customerPercentagesAsync = ref.watch(getCustomerInsights);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Segmentation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            customerPercentagesAsync.when(
              data: (data) {
                // data is List<CustomerPercentage>
                if (data.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No customer segmentation data available.', style: TextStyle(color: Colors.grey)),
                  );
                }
                double newRevenue = 0;
                double oldRevenue = 0;
                for (var item in data) {
                  if (item.type.toLowerCase() == 'new') {
                    newRevenue = item.value;
                  } else if (item.type.toLowerCase() == 'old') {
                    oldRevenue = item.value;
                  }
                }
                final double totalRevenue = newRevenue + oldRevenue;
                final double newPercent = totalRevenue == 0 ? 0 : (newRevenue / totalRevenue) * 100;
                final double oldPercent = totalRevenue == 0 ? 0 : (oldRevenue / totalRevenue) * 100;
                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: newPercent,
                              title: '${newPercent.toStringAsFixed(1)}%',
                              color: Colors.green,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: oldPercent,
                              title: '${oldPercent.toStringAsFixed(1)}%',
                              color: Colors.blue,
                              radius: 60,
                            ),
                          ],
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('New Customers: ${newPercent.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.green)),
                    Text('Old Customers: ${oldPercent.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.blue)),
                  ],
                );
              },
              loading: () => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: [
                    Container(height: 200, width: double.infinity, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    Container(height: 16, width: 120, color: Colors.grey[300]),
                    const SizedBox(height: 6),
                    Container(height: 16, width: 120, color: Colors.grey[300]),
                  ],
                ),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Failed to load customer segmentation', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Displays the high-value customers
  Widget buildHighValueCustomers() {
    final getTopCustomersByRevenueAsync = ref.watch(getTopCustomersByRevenue);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'High-Value Customers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            getTopCustomersByRevenueAsync.when(
              data: (highValueCustomers) {
                if (highValueCustomers.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No high-value customers available.', style: TextStyle(color: Colors.grey)),
                  );
                }
                return Column(
                children: [
                  for (int i = 0; i < (_showAllCustomers ? highValueCustomers.length : 3); i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(highValueCustomers[i].name),
                            Text('Rs.${highValueCustomers[i].value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllCustomers = !_showAllCustomers;
                      });
                    },
                    child: Text(
                      _showAllCustomers ? 'Show Less' : 'Show More',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              );
              },
              loading: () => Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(width: 100, height: 16, color: Colors.grey[300]),
                              Container(width: 60, height: 16, color: Colors.grey[300]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Container(height: 36, width: 100, margin: const EdgeInsets.only(top: 8), color: Colors.grey[300]),
                ],
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Failed to load high-value customers', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Displays inactive customers and a notify button
  Widget buildInactiveCustomers() {
    final bottomCustomersRevenueAsync = ref.watch(getBottomCustomersByRevenue);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inactive Customers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            bottomCustomersRevenueAsync.when(
              data: (inactiveCustomers) {
                if (inactiveCustomers.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No inactive customers found.', style: TextStyle(color: Colors.grey)),
                  );
                };
                return Column(
                children: [
                  ...inactiveCustomers.map((customer) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(customer.name, style: TextStyle(color: Colors.red)),
                      )),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Notify action here
                      print('Notify inactive customers pressed');
                    },
                    child: const Text('Notify Inactive Customers'),
                  ),
                ],
              );
              },
              loading: () => Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 36,
                      width: 180,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Failed to load inactive customers', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
