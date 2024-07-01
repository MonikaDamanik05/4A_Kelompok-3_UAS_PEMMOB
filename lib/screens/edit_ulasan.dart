// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/cubit/data_login_cubit.dart';

class EditUlasanScreen extends StatefulWidget {
  const EditUlasanScreen({super.key});

  @override
  _EditUlasanScreenState createState() => _EditUlasanScreenState();
}

class _EditUlasanScreenState extends State<EditUlasanScreen> {
  List<dynamic> ulasanList = [];
  List<dynamic> filteredUlasanList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUlasanByIdUser();
    searchController.addListener(() {
      filterUlasanList();
    });
  }

  Future<void> fetchUlasanByIdUser() async {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;
    int idUser = currentState.idUser;

    final response = await http.get(Uri.parse(
        'http://192.168.53.185:5000/api/v1/ulasan/read_by_id_user/$idUser'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response Data: $data'); // Debugging: Print response data

      setState(() {
        ulasanList = data['datas'];
        filteredUlasanList = ulasanList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Gagal memuat ulasan');
    }
  }

  void filterUlasanList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUlasanList = ulasanList.where((ulasan) {
        return ulasan['nama_kuliner'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> updateUlasan(int idUlasan, int idKuliner, int idUser,
      String deskripsi, int bintang) async {
    final response = await http.put(
      Uri.parse('http://192.168.53.185:5000/api/v1/ulasan/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_ulasan': idUlasan,
        'id_kuliner': idKuliner,
        'id_user': idUser,
        'deskripsi': deskripsi,
        'bintang': bintang,
      }),
    );

    if (response.statusCode == 200) {
      print('Review updated successfully');

      // Menampilkan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ulasan berhasil diperbarui')),
      );

      fetchUlasanByIdUser();
    } else {
      print('Failed to update review');
      throw Exception('Gagal memperbarui ulasan');
    }
  }

  void showEditDialog(Map<String, dynamic> ulasan) {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;
    int idUser = currentState.idUser;

    // Debugging: Print ulasan to console
    print('Ulasan: $ulasan');

    // Memastikan id_kuliner ada di dalam ulasan
    if (ulasan.containsKey('id_kuliner')) {
      print('ID Kuliner ditemukan: ${ulasan['id_kuliner']}');
    } else {
      print('ID Kuliner tidak ditemukan');
    }

    // Mengisi id_kuliner dengan nilai dari data ulasan yang dipilih
    String idKuliner =
        ulasan['id_kuliner'] != null ? ulasan['id_kuliner'].toString() : '';
    print('ID Kuliner: $idKuliner'); // Debugging: Print ID Kuliner
    // ignore: unused_local_variable
    TextEditingController idKulinerController =
        TextEditingController(text: idKuliner);
    TextEditingController deskripsiController =
        TextEditingController(text: ulasan['deskripsi']);
    int selectedStarCount = int.tryParse(ulasan['bintang'].toString()) ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor:
                Colors.grey[900], // Ubah warna background menjadi lebih gelap
            title: const Text(
              'Edit Ulasan',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sembunyikan TextField untuk idKuliner dan idUser
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: deskripsiController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedStarCount
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedStarCount = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (idKuliner.isNotEmpty) {
                    updateUlasan(
                      ulasan['id_ulasan'],
                      int.parse(idKuliner),
                      idUser,
                      deskripsiController.text,
                      selectedStarCount,
                    ).then((_) {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ulasan Saya'),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari Kuliner',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUlasanList.length,
                    itemBuilder: (context, index) {
                      int starCount = 0;
                      try {
                        starCount = int.parse(
                            filteredUlasanList[index]['bintang'].toString());
                      } catch (e) {
                        starCount = 0;
                      }

                      return GestureDetector(
                        onTap: () => showEditDialog(filteredUlasanList[index]),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredUlasanList[index]['nama_kuliner'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                filteredUlasanList[index]['deskripsi'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    starIndex < starCount
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow[600],
                                    size: 24.0,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
