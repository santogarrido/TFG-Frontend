import 'package:flutter/material.dart';
import 'package:pointmaster/models/booking.dart';
import 'package:pointmaster/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    super.key,
    required this.booking,
  });

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.read<BookingProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC4AD55),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: const CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(Icons.event_available, color: Colors.white),
        ),
        title: Text(
          booking.facilityName ?? 'Club',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Pista: ${booking.courtName ?? 'ID ${booking.courtId}'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text('Precio: ${booking.courtPrice.toStringAsFixed(2)} EUR'),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatDate(booking.courtDateTimeBooking)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatTime(booking.courtDateTimeBooking)),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cancelar reserva'),
                content: const Text('Quieres cancelar esta reserva?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Si'),
                  ),
                ],
              ),
            );

            if (confirm != true) return;

            final messenger = ScaffoldMessenger.of(context);
            await bookingProvider.deleteBooking(booking.id);

            if (bookingProvider.errorMessage != null) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(bookingProvider.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Reserva cancelada'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          icon: const Icon(Icons.cancel),
          label: const Text('Cancelar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
