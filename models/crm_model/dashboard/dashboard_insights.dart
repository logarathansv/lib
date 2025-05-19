class WeeklyCustomerData {
  final DateTime weekStart;
  final int customerCount;

  WeeklyCustomerData({
    required this.weekStart,
    required this.customerCount,
  });

  factory WeeklyCustomerData.fromJson(Map<String, dynamic> json) {
    return WeeklyCustomerData(
      weekStart: DateTime.parse(json['weekStart']),
      customerCount: json['customerCount'],
    );
  }
}
class MonthlyCustomerData {
  final DateTime monthStart;
  final int customerCount;

  MonthlyCustomerData({
    required this.monthStart,
    required this.customerCount,
  });

  factory MonthlyCustomerData.fromJson(Map<String, dynamic> json) {
    return MonthlyCustomerData(
      monthStart: DateTime.parse(json['monthStart']),
      customerCount: json['customerCount'],
    );
  }
}
class RetentionStats {
  final double retentionRate;
  final double churnRate;

  RetentionStats({
    required this.retentionRate,
    required this.churnRate,
  });

  factory RetentionStats.fromJson(Map<String, dynamic> json) {
    return RetentionStats(
      retentionRate: (json['retentionRate'] as num).toDouble(),
      churnRate: (json['churnRate'] as num).toDouble(),
    );
  }
}
