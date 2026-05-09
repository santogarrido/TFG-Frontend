import 'package:flutter/material.dart';
import 'package:pointmaster/models/booking.dart';
import 'package:pointmaster/models/response_api.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/services/booking_service_api.dart';

class BookingProvider extends ChangeNotifier {
  final BookingServiceApi bookingService;
  final UserProvider userProvider;
  String? errorMessage;
  bool loading = false;
  List<Booking> bookings = [];
  List<Booking> myBookings = [];

  BookingProvider(this.bookingService, this.userProvider);

  // Get all bookings
  Future<void> getAllBookings() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = userProvider.activeUser!.token;
      final ResponseApi response = await bookingService.getAllBookings(token!);

      if (response.success && response.data != null) {
        bookings = (response.data as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      } else {
        bookings = [];
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //Get bookings by Court
  Future<void> getBookingsByCourt(int courtId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = userProvider.activeUser!.token;
      final ResponseApi response = await bookingService.getBookingsByCourt(
        courtId,
        token!,
      );

      if (response.success && response.data != null) {
        bookings = (response.data as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      } else {
        bookings = [];
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Get bookings by facility
  Future<void> getBookingsByFacility(int facilityId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = userProvider.activeUser!.token;
      final ResponseApi response = await bookingService.getBookingsByFacility(
        facilityId,
        token!,
      );

      if (response.success && response.data != null) {
        bookings = (response.data as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      } else {
        bookings = [];
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Get bookings by user
  Future<void> getBookingsByUser(int userId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = userProvider.activeUser!.token;
      final ResponseApi response = await bookingService.getBookingsByUser(
        userId,
        token!,
      );

      if (response.success && response.data != null) {
        myBookings = (response.data as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      } else {
        myBookings = [];
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Add booking
  Future<void> addBooking({
    required int userId,
    required int courtId,
    required DateTime bookingDateTime,
    required DateTime courtDateTimeBooking,
  }) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = userProvider.activeUser!.token;
      final ResponseApi response = await bookingService.addBooking(
        userId,
        courtId,
        bookingDateTime,
        courtDateTimeBooking,
        token!,
      );

      if (response.success && response.data != null) {
        final newBooking = Booking.fromJson(response.data);
        bookings.add(newBooking);
        myBookings.add(newBooking);
        notifyListeners();
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Delete
  Future<void> deleteBooking(int bookingId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = userProvider.activeUser!.token;
      final ResponseApi response = await bookingService.deleteBooking(
        bookingId,
        token!,
      );

      if (response.success) {
        bookings.removeWhere((b) => b.id == bookingId);
        myBookings.removeWhere((b) => b.id == bookingId);
        notifyListeners();
      } else {
        errorMessage = response.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
