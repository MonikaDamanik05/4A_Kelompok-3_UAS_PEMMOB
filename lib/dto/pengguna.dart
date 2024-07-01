class Pengguna {
  int idUser;
  String username;
  String password;
  String email;
  String role;
  DateTime createdAt;

  Pengguna({
    required this.idUser,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      idUser: json["id_user"] as int,
      username: json["username"] as String,
      password: json["password"] as String,
      email: json["email"] as String,
      role: json["role"] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_user": idUser,
      "username": username,
      "password": password,
      "email": email,
      "role": role,
      "created_at":
          createdAt.toIso8601String(), // Format DateTime ke ISO 8601 string
    };
  }

  @override
  String toString() {
    return 'Pengguna{idUser: $idUser, username: $username, email: $email, role: $role}';
  }
}
