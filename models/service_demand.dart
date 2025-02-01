// models/service_demand.dart
class ServiceDemand {
  final String serviceName;
  final int month;  // Use a number to represent the month (1 - 12)
  final int demand;

  ServiceDemand({
    required this.serviceName,
    required this.month,
    required this.demand,
  });
}
