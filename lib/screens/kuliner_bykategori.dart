// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/screens/ulasan_screen.dart';

class KulinerByKategoriScreen extends StatefulWidget {
  final String kategori;

  const KulinerByKategoriScreen({super.key, required this.kategori});

  @override
  _KulinerByKategoriScreenState createState() =>
      _KulinerByKategoriScreenState();
}

class _KulinerByKategoriScreenState extends State<KulinerByKategoriScreen> {
  List<dynamic> kulinerList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchKulinerByKategori();
  }

  Future<void> fetchKulinerByKategori() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.53.185:5000/api/v1/kuliner/read_by_kategori?kategori=${widget.kategori}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          kulinerList = data['datas'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Gagal memuat kuliner';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat kuliner: $e';
      });
    }
  }

  Future<double?> fetchRating(int idKuliner) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.53.185:5000/api/v1/kuliner/rating/$idKuliner'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['rating'] != null
            ? double.parse(data['rating'].toString())
            : null;
      } 
    } catch (e) {
      print('Error fetching rating: $e');
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Menu Kuliner"),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: kulinerList.length,
                  itemBuilder: (context, index) {
                    final kuliner = kulinerList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UlasanScreen(
                              kulinerId: kuliner['id_kuliner'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kuliner['foto'] != null &&
                                      kuliner['foto'].isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        'http://192.168.53.185:5000/api/v1/kuliner/photo/${kuliner['id_kuliner']}',
                                        width: double.infinity,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 10),
                              Text(
                                kuliner['nama_kuliner'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Harga: ${kuliner['harga']}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Lokasi: ${kuliner['lokasi']}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              FutureBuilder<double?>(
                                future: fetchRating(int.parse(
                                    kuliner['id_kuliner'].toString())),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final rating = snapshot.data;
                                    if (rating != null) {
                                      return Text(
                                        'Rating: ${rating.toStringAsFixed(1)}',
                                        style: const TextStyle(fontSize: 18),
                                      );
                                    } else {
                                      return const Text(
                                        'Belum memiliki rating',
                                        style: TextStyle(fontSize: 18),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
