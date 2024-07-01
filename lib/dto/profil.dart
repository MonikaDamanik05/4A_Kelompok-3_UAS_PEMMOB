class Profile {
  final int idUser;
  final String? namaLengkap;
  final String? alamat;
  final String? email;
  final String? username;
  final String? foto;

  Profile({
    required this.idUser,
    this.namaLengkap,
    this.alamat,
    this.email,
    this.username,
    this.foto,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      idUser: json['id_user'],
      namaLengkap: json['nama_lengkap'],
      alamat: json['alamat'],
      email: json['email'],
      username: json['username'],
      foto: json['foto'],
    );
  }

  Profile copyWith({
    int? idUser,
    String? namaLengkap,
    String? alamat,
    String? email,
    String? username,
    String? foto,
  }) {
    return Profile(
      idUser: idUser ?? this.idUser,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      alamat: alamat ?? this.alamat,
      email: email ?? this.email,
      username: username ?? this.username,
      foto: foto ?? this.foto,
    );
  }
}