import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pointmaster/models/court.dart';
import 'package:pointmaster/models/facility.dart';
import 'package:pointmaster/models/user.dart';
import 'package:pointmaster/providers/booking_provider.dart';

class CourtBookingScreen extends StatefulWidget {
  final Court court;
  final Facility facility;
  final User user;

  const CourtBookingScreen({
    super.key,
    required this.court,
    required this.facility,
    required this.user,
  });

  @override
  State<CourtBookingScreen> createState() => _CourtBookingScreenState();
}

class _CourtBookingScreenState extends State<CourtBookingScreen> {
  late BookingProvider bookingProvider;

  @override
  void initState() {
    super.initState();

    bookingProvider = Provider.of<BookingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.court.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
      ),
      body: BookingCalendar(
        bookingService: _bookingService(),
        getBookingStream: _getBookingStream,
        uploadBooking: _uploadBooking,
        bookingButtonText: 'Reservar',
        convertStreamResultToDateTimeRanges:
            _convertStreamResultToDateTimeRanges,
        lastDay: DateTime.now().add(const Duration(days: 7)),
        loadingWidget: const Center(child: CircularProgressIndicator()),
        uploadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatDateTime(DateTime dateTime) {
    final day = _twoDigits(dateTime.day);
    final month = _twoDigits(dateTime.month);
    final year = dateTime.year;
    final hour = _twoDigits(dateTime.hour);
    final minute = _twoDigits(dateTime.minute);
    return '$day/$month/$year $hour:$minute';
  }

  Future<bool> _showBookingConfirmationDialog(DateTime bookingDateTime) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirmar reserva',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                Text('Pista: ${widget.court.name}'),
                const SizedBox(height: 8),
                Text('Dia: ${_formatDateTime(bookingDateTime)}'),
                const SizedBox(height: 8),
                Text('Precio: ${widget.court.price.toStringAsFixed(2)} EUR'),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.black54),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Informacion: si deseas cancelar la reserva, se devolvera el dinero solo si la cancelacion se realiza con mas de 24 horas de antelacion al momento de la reserva.',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext, false),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(sheetContext, true),
                        child: const Text('Confirmar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return confirmed ?? false;
  }

  // Parse String to DateTime
  DateTime _timeStringToDateTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Create BookingService for the calendar
  BookingService _bookingService() {
    return BookingService(
      serviceName: widget.court.name,
      serviceDuration: widget.court.bookingDuration,
      bookingStart: _timeStringToDateTime(widget.facility.openTime),
      bookingEnd: _timeStringToDateTime(widget.facility.closeTime),
    );
  }

  // Get the bookings of this court
  Stream<List<dynamic>> _getBookingStream({
    required DateTime start,
    required DateTime end,
  }) async* {
    await bookingProvider.getBookingsByCourt(widget.court.id);
    yield bookingProvider.bookings;
  }

  //Create the book at the selected time
  Future<dynamic> _uploadBooking({required BookingService newBooking}) async {
    final now = DateTime.now();
    final courtDateTimeBooking = newBooking.bookingStart;

    if (courtDateTimeBooking.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se puede reservar una hora pasada"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    final confirmed = await _showBookingConfirmationDialog(courtDateTimeBooking);
    if (!confirmed) {
      return false;
    }

    final bookingDateTime = DateTime.now();

    await bookingProvider.addBooking(
      userId: widget.user.id!,
      courtId: widget.court.id,
      bookingDateTime: bookingDateTime,
      courtDateTimeBooking: courtDateTimeBooking,
      courtPrice: widget.court.price,
    );

    if (bookingProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookingProvider.errorMessage!),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reserva creada correctamente'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    await bookingProvider.getBookingsByCourt(widget.court.id);

    return true;
  }

  // Load unavailable hours
  List<DateTimeRange> _convertStreamResultToDateTimeRanges({
    required dynamic streamResult,
  }) {
    final List<DateTimeRange> blockedRanges = [];
    final bookings = streamResult as List;

    final now = DateTime.now();

    // Existing bookings
    for (final b in bookings) {
      final start = b.courtDateTimeBooking;
      final end = start.add(Duration(minutes: widget.court.bookingDuration));

      blockedRanges.add(DateTimeRange(start: start, end: end));
    }

    // Block past hours
    final opening = _timeStringToDateTime(widget.facility.openTime);
    final closing = _timeStringToDateTime(widget.facility.closeTime);

    DateTime cursor = opening;

    while (cursor.isBefore(now) && cursor.isBefore(closing)) {
      final end = cursor.add(Duration(minutes: widget.court.bookingDuration));

      blockedRanges.add(DateTimeRange(start: cursor, end: end));

      cursor = end;
    }

    return blockedRanges;
  }
}
