class Booking {
  int id;
  int userId;
  int courtId;
  String? facilityName;
  String? courtName;
  DateTime bookingDateTime;
  DateTime courtDateTimeBooking;
  double courtPrice;
  bool deleted;

  Booking({
    required this.id,
    required this.userId,
    required this.courtId,
    this.facilityName,
    this.courtName,
    required this.bookingDateTime,
    required this.courtDateTimeBooking,
    required this.courtPrice,
    required this.deleted,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    userId: json['userId'],
    courtId: json['courtId'],
    facilityName: json['facilityName'] ??
        json['clubName'] ??
        (json['facility'] is Map ? json['facility']['name'] : null) ??
        (json['court'] is Map && json['court']['facility'] is Map
            ? json['court']['facility']['name']
            : null),
    courtName: json['courtName'] ??
        (json['court'] is Map ? json['court']['name'] : null),
    bookingDateTime: DateTime.parse(json['bookingDateTime']),
    courtDateTimeBooking: DateTime.parse(json['courtDateTimeBooking']),
    courtPrice: (json['courtPrice'] as num?)?.toDouble() ?? 0,
    deleted: json['deleted'] ?? false,
  );
}
