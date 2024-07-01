class Kuliner {
  final int idKuliner;
  final int harga;
  final String? namakuliner;
  final String? kategori;
  final String? lokasi;
  final String? foto;
  final double? rating;

  Kuliner({
    required this.idKuliner,
    required this.namakuliner,
    required this.harga,
    required this.kategori,
    required this.lokasi,
    required this.foto,
     required this.rating,
  });

  factory Kuliner.fromJson(Map<String, dynamic> json) {
    return Kuliner(
      idKuliner: json['id_kuliner'],
      namakuliner: json['nama_kuliner'],
      harga: json['harga'],
      kategori: json['kategori'],
      lokasi: json['lokasi'],
      foto: json['foto'],
      rating: json['rating'] != null ? (json['rating']as num).toDouble() : null,
    );
  }
}