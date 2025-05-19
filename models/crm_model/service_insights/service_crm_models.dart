class ServiceData {
  final String serviceName;
  final int bookings;

  ServiceData({required this.serviceName, required this.bookings});

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      serviceName: json['service'],
      bookings: json['count'],
    );
  }
}

class ServiceRevenueData {
  final String service;
  final int revenue;

  ServiceRevenueData({required this.service, required this.revenue});

  factory ServiceRevenueData.fromJson(Map<String, dynamic> json) {
    return ServiceRevenueData(
      service: json['service'],
      revenue: json['cost'],
    );
  }
}

class TrendData {
  final String year;
  final int bookings;

  TrendData({required this.year, required this.bookings});

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      year: json['year'],
      bookings: json['count'],
    );
  }
}