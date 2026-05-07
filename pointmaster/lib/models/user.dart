class User {
  int? id;
  String? name;
  String? secondName;
  String? email;
  String username;
  String? role;
  bool? activated;
  bool? deleted;
  String? token;

  User({
    this.id,
    this.name,
    this.secondName,
    this.email,
    required this.username,
    this.role,
    this.activated,
    this.deleted,
    this.token,
  });

  factory User.fromLoginJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    role: json['role'],
    token: json['token'],
  );

  factory User.fromRegisterJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    secondName: json['secondName'],
    email: json['email'],
    username: json['username']
  );

  factory User.fromUserDTO(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    secondName: json['secondName'],
    email: json['email'],
    username: json['username'],
    role: json['role'],
    activated: json['activated'],
    deleted: json['deleted']
  );
}
