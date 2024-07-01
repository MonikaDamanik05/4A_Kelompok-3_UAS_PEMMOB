class Komentar {
  final int idKuliner;
  final int idUser;
  final String deskripsi;
  final String bintang;
  final String foto;

  Komentar({
    required this.idKuliner,
    required this.idUser,
    required this.deskripsi,
    required this.bintang,
    required this.foto,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      idKuliner: json['id_kuliner'],
      idUser: json['id_user'],
      deskripsi: json['deskripsi'],
      bintang: json['bintang'],
      foto: json['foto'],
    );
  }
}
