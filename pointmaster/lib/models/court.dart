class Court {

  int id;
  String name;
  String category;
  int bookingDuration;
  bool activated;
  bool deleted;
  int facilityId;

  Court({
    required this.id,
    required this.name,
    required this.category,
    required this.bookingDuration,
    required this.activated,
    required this.deleted,
    required this.facilityId
  });

  factory Court.fromCourtsJson(Map<String, dynamic> json) => Court(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    bookingDuration: json['bookingDuration'],
    activated: json['activated'],
    deleted: json['deleted'],
    facilityId: json['facilityId']
  ); 

}