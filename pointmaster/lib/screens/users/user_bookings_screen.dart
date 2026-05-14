import 'package:flutter/material.dart';
import 'package:pointmaster/models/court.dart';
import 'package:pointmaster/models/facility.dart';
import 'package:pointmaster/models/booking.dart';
import 'package:pointmaster/models/response_api.dart';
import 'package:pointmaster/models/user.dart';
import 'package:pointmaster/providers/booking_provider.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/services/court_service.dart';
import 'package:pointmaster/services/facility_service.dart';
import 'package:pointmaster/widgets/screens/booking_card.dart';
import 'package:provider/provider.dart';

class UserBookingsScreen extends StatefulWidget {
  final User user;

  const UserBookingsScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserBookingsScreen> createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  final CourtService _courtService = CourtService();
  final FacilityService _facilityService = FacilityService();

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadBookings);
  }

  Future<void> _loadBookings() async {
    final userId = widget.user.id;
    if (userId == null) return;
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    await bookingProvider.getBookingsByUser(userId);
    await _enrichBookingNames(bookingProvider.myBookings);
  }

  Future<void> _enrichBookingNames(List<Booking> bookings) async {
    final token = Provider.of<UserProvider>(context, listen: false).activeUser?.token;
    if (token == null || bookings.isEmpty) return;

    final Map<int, Court> courtCache = {};
    final Map<int, Facility> facilityCache = {};

    for (final booking in bookings) {
      final int courtId = booking.courtId;

      if (!courtCache.containsKey(courtId)) {
        final ResponseApi courtResponse = await _courtService.getCourtById(courtId, token);
        if (courtResponse.success && courtResponse.data is Map) {
          courtCache[courtId] = Court.fromCourtsJson(
            Map<String, dynamic>.from(courtResponse.data),
          );
        }
      }

      final court = courtCache[courtId];
      if (court != null) {
        booking.courtName = court.name;
        final facilityId = court.facilityId;

        if (!facilityCache.containsKey(facilityId)) {
          final ResponseApi facilityResponse = await _facilityService.getFacilityById(
            facilityId,
            token,
          );
          if (facilityResponse.success && facilityResponse.data is Map) {
            facilityCache[facilityId] = Facility.fromFacilitiesJson(
              Map<String, dynamic>.from(facilityResponse.data),
            );
          }
        }

        booking.facilityName = facilityCache[facilityId]?.name;
      }
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        title: const Text('Mis reservas'),
      ),
      body: bookingProvider.loading && bookingProvider.myBookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : bookingProvider.errorMessage != null && bookingProvider.myBookings.isEmpty
              ? Center(
                  child: Text(
                    bookingProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: bookingProvider.myBookings.length,
                    itemBuilder: (_, index) {
                      return BookingCard(booking: bookingProvider.myBookings[index]);
                    },
                  ),
                ),
    );
  }
}
