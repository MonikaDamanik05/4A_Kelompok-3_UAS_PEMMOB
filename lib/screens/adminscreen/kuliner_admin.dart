// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_app/screens/adminscreen/create_kuliner.dart';

class KulinerByKategoriAdminScreen extends StatefulWidget {
  final String kategori;

  const KulinerByKategoriAdminScreen({super.key, required this.kategori});

  @override
  _KulinerByKategoriAdminScreenState createState() =>
      _KulinerByKategoriAdminScreenState();
}

class _KulinerByKategoriAdminScreenState
    extends State<KulinerByKategoriAdminScreen> {
  List kulinerList = [];
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
      } else {
        throw Exception('Failed to fetch rating');
      }
    } catch (e) {
      print('Error fetching rating: $e');
      return null;
    }
  }

  Future<void> _pickImage(int idKuliner) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _uploadImage(idKuliner, image);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage(int idKuliner, File image) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.53.185:5000/api/v1/kuliner/upload'));
    request.fields['id_kuliner'] = idKuliner.toString();
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto berhasil diunggah')),
      );
      fetchKulinerByKategori();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah foto')),
      );
    }
  }

  void _showEditDialog(Map kuliner) {
    final _formKey = GlobalKey<FormState>();
    final _namaController =
        TextEditingController(text: kuliner['nama_kuliner']);
    final _hargaController =
        TextEditingController(text: kuliner['harga'].toString());
    final _lokasiController = TextEditingController(text: kuliner['lokasi']);
    String _kategori = kuliner['kategori'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Kuliner'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama Kuliner'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama kuliner tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hargaController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lokasiController,
                  decoration: const InputDecoration(labelText: 'Lokasi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _kategori,
                  items: [
                    'Tradisional',
                    'AsianFood',
                    'WesternFood',
                    'StreetFood',
                    'VeganFood',
                    'Dessert'
                  ]
                      .map((kategori) => DropdownMenuItem(
                            value: kategori,
                            child: Text(kategori),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _kategori = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Kategori'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateKuliner(
                      kuliner['id_kuliner'],
                      _namaController.text,
                      _hargaController.text,
                      _lokasiController.text,
                      _kategori);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data Berhasil Diperbarui')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateKuliner(
      int id, String nama, String harga, String lokasi, String kategori) async {
    final response = await http.put(
      Uri.parse('http://192.168.53.185:5000/api/v1/kuliner/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_kuliner': id,
        'nama_kuliner': nama,
        'harga': harga,
        'lokasi': lokasi,
        'kategori': kategori,
      }),
    );

    if (response.statusCode == 200) {
      fetchKulinerByKategori();
    } else {
      throw Exception('Failed to update kuliner');
    }
  }

  Future<void> _deleteKuliner(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Anda yakin ingin menghapus kuliner ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final response = await http.delete(
                    Uri.parse(
                        'http://192.168.53.185:5000/api/v1/kuliner/delete/$id'),
                  );
                  if (response.statusCode == 200) {
                    fetchKulinerByKategori();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kuliner berhasil dihapus')),
                    );
                  }
                } catch (e) {
                  print('Error deleting kuliner: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menghapus kuliner')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kuliner['foto'] != null &&
                                    kuliner['foto'].isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'http://192.168.53.185:5000/api/v1/kuliner/photo/${kuliner['id_kuliner']}',
                                      width: double.infinity,
                                      height: 250, // Increase the height
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Text('Failed to load image'),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10),
                            Text(
                              kuliner['nama_kuliner'],
                              style: const TextStyle(
                                fontSize: 22, // Increase font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Harga: ${kuliner['harga']}',
                              style:
                                  const TextStyle(fontSize: 18), // Increase font size
                            ),
                            Text(
                              'Lokasi: ${kuliner['lokasi']}',
                              style:
                                  const TextStyle(fontSize: 18), // Increase font size
                            ),
                            FutureBuilder<double?>(
                              future: fetchRating(
                                  int.parse(kuliner['id_kuliner'].toString())),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.camera_alt,
                                      color: Colors.green),
                                  onPressed: () =>
                                      _pickImage(kuliner['id_kuliner']),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showEditDialog(kuliner),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      _deleteKuliner(kuliner['id_kuliner']),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateKulinerScreen()),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
