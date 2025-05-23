import 'package:flutter/material.dart';
import 'package:sklyit_business/utils/crm/data_filter.dart';
import 'package:sklyit_business/widgets/crm/customer_list.dart';
import 'package:sklyit_business/widgets/crm/order_list.dart';
import 'package:sklyit_business/widgets/crm/product_list.dart';

enum CRMSection { orders, customers, products }

class CustomCRM extends StatefulWidget {
  @override
  _CustomCRMState createState() => _CustomCRMState();
}

class _CustomCRMState extends State<CustomCRM> {
  DateTime? startDate;
  DateTime? endDate;
  CRMSection selectedSection = CRMSection.orders;

  final Color primaryYellow = Color.fromARGB(255, 245, 196, 69);
  final Color accentTeal = Color.fromARGB(255, 10, 138, 134);
  final Color darkBlueGrey = Color.fromARGB(255, 47, 72, 88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
        ),
        iconTheme: IconThemeData(color: primaryYellow),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: accentTeal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentTeal, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CRMSection>(
                  value: selectedSection,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  iconEnabledColor: accentTeal,
                  style: TextStyle(
                    color: darkBlueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSection = value;
                      });
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: CRMSection.orders,
                      child: Text("Orders"),
                    ),
                    DropdownMenuItem(
                      value: CRMSection.customers,
                      child: Text("Customers"),
                    ),
                    DropdownMenuItem(
                      value: CRMSection.products,
                      child: Text("Products"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: primaryYellow.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryYellow, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DateFilter(
                onDateRangeSelected: (start, end) {
                  setState(() {
                    startDate = start;
                    endDate = end;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Builder(
              builder: (_) {
                switch (selectedSection) {
                  case CRMSection.orders:
                    return OrderList(
                      startDate: startDate,
                      endDate: endDate,
                      headerColor: primaryYellow,
                      borderColor: darkBlueGrey,
                      showExports: true,
                    );
                  case CRMSection.customers:
                    return CustomerList(
                      startDate: startDate,
                      endDate: endDate,
                      headerColor: primaryYellow,
                      borderColor: darkBlueGrey,
                      showExports: true,
                    );
                  case CRMSection.products:
                    return ProductList(
                      startDate: startDate,
                      endDate: endDate,
                      headerColor: primaryYellow,
                      borderColor: darkBlueGrey,
                      showExports: true,
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
