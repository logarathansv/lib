class Booking {
  final String BookingId;
  final String customerName;
  Map<String, dynamic> service;
  final String date;
  final String time;
  final String serviceMode; // "At Home" or "At Place"
  String status;
  final String? addressCity;
  final String? addressStreet;
  final String? addressPincode;
  final String? addressState;
  final String? addressDoorno;
  final String? customerPhone;

  Booking({
    required this.BookingId,
    required this.customerName,
    required this.service,
    required this.date,
    required this.time,
    required this.serviceMode,
    required this.status,
    required this.addressCity,
    required this.addressStreet,
    required this.addressPincode,
    required this.addressState,
    required this.addressDoorno,
    required this.customerPhone,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> service = {
      'Sid': json['service']['Sid'],
      'ServiceName': json['service']['ServiceName'],
      'ServiceCost': json['service']['ServiceCost'],
    };

    return Booking(
      BookingId: json['BookingID'],
      customerName: json['customer']['name'],
      customerPhone: json['customer']['mobileno'], // Assuming 'phone' is the field for phone number
      service: service,
      date: json['ServiceDate'],
      time: json['ServiceTime'],
      serviceMode: json['BookedMode'],
      status: json['Status'],
      addressCity: json['customer']['addressCity'],
      addressStreet: json['customer']['addressStreet'],
      addressPincode: json['customer']['addressPincode'],
      addressState: json['customer']['addressState'],
      addressDoorno: json['customer']['addressDoorno'],
    );
  }
}