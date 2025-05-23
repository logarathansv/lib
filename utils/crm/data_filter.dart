import 'package:flutter/material.dart';

class DateFilter extends StatelessWidget {
  final Function(DateTime, DateTime) onDateRangeSelected;
  final Color todayColor;
  final Color tomorrowColor;
  final Color rangeColor;
  final Color textColor;

  DateFilter({
    required this.onDateRangeSelected,
    this.todayColor = const Color(0xFFF5C445),
    this.tomorrowColor = const Color(0xFF0A8A86),
    this.rangeColor = const Color(0xFF2F4858),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: todayColor,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              DateTime today = DateTime.now();
              onDateRangeSelected(today, today);
            },
            child: Text('Today'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tomorrowColor,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              DateTime tomorrow = DateTime.now().add(Duration(days: 1));
              onDateRangeSelected(tomorrow, tomorrow);
            },
            child: Text('Tomorrow'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: rangeColor,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                onDateRangeSelected(picked.start, picked.end);
              }
            },
            child: Text('Select Range'),
          ),
        ],
      ),
    );
  }
}
