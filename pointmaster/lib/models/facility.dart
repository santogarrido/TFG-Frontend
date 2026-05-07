class Facility {

  int id;
  String name;
  String openTime;
  String closeTime;
  String location;
  bool activated;
  bool deleted;

  Facility({
    required this.id,
    required this.name,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.activated,
    required this.deleted
  });

  factory Facility.fromFacilitiesJson(Map<String, dynamic> json) => Facility(
    id: json['id'], 
    name: json['name'], 
    openTime: json['openTime'], 
    closeTime: json['closeTime'], 
    location: json['location'], 
    activated: json['activated'] ?? false,
    deleted: json['deleted'] ?? false,
  );

}
