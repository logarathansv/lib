import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/crm/tabs/customer_analytics.dart';
import 'package:sklyit_business/screens/crm/tabs/dashboard.dart';
import 'package:sklyit_business/screens/crm/tabs/performance.dart';
import 'package:sklyit_business/screens/crm/tabs/revenue_insights.dart';
import 'package:sklyit_business/screens/crm/tabs/service_insights.dart';

class CRMPage extends StatefulWidget {
  const CRMPage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CRMPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'CRM',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: const Color(0xFF028F83),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelPadding: const EdgeInsets.symmetric(
                  horizontal:
                      20.0), // Add horizontal padding to ensure centering
              tabs: const [
                Tab(
                    icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDashboardSquare02,
                  color: Colors.black,
                  size: 24.0,
                )),
                Tab(
                    icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedIdea01,
                  color: Colors.black,
                  size: 24.0,
                )),
                Tab(
                    icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserMultiple,
                  color: Colors.black,
                  size: 24.0,
                )),
                Tab(
                    icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedCoinsDollar,
                  color: Colors.black,
                  size: 24.0,
                )),
                Tab(
                    icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedLaptopPerformance,
                  color: Colors.black,
                  size: 24.0,
                )),
              ],
            ),
          ),
          // Expanded widget to ensure the TabBarView takes up remaining space
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DashboardScreen(),
                ServiceInsightsPage(),
                CustomerAnalyticsPage(),
                RevenueInsightsPage(),
                PerformanceComparison(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
