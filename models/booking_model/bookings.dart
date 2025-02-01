class Booking {
  final String customerName;
  final List<String> services;
  final String date;
  final String time;
  final String serviceMode; // "At Home" or "At Place"
  final bool isNewCustomer;
  final String address; // Customer address

  Booking({
    required this.customerName,
    required this.services,
    required this.date,
    required this.time,
    required this.serviceMode,
    required this.isNewCustomer,
    required this.address
  });
}