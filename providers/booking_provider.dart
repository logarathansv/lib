import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model/bookings.dart';
import '../providers/business_main.dart';
import '../api/Booking/booking_api.dart';

final getbookingProvider = FutureProvider<List<Booking>>((ref) async{
  return await BookingService(ref.watch(apiClientProvider).dio).getBookings();
});

final bookingServiceProvider = FutureProvider<BookingService>((ref) => BookingService(ref.watch(apiClientProvider).dio));