class Booking {
  int id;
  int userId;
  int courtId;
  DateTime bookingDateTime;
  DateTime courtDateTimeBooking;
  bool deleted;

  Booking({
    required this.id,
    required this.userId,
    required this.courtId,
    required this.bookingDateTime,
    required this.courtDateTimeBooking,
    required this.deleted,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    userId: json['userId'],
    courtId: json['courtId'],
    bookingDateTime: DateTime.parse(json['bookingDateTime']),
    courtDateTimeBooking: DateTime.parse(json['courtDateTimeBooking']),
    deleted: json['deleted'] ?? false,
  );
}
