// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateKulinerScreen extends StatefulWidget {
  const CreateKulinerScreen({super.key});

  @override
  _CreateKulinerScreenState createState() => _CreateKulinerScreenState();
}

class _CreateKulinerScreenState extends State<CreateKulinerScreen> {
  final _formKey = GlobalKey<FormState>();
  String _namaKuliner = '';
  String _kategori = 'Tradisional';
  String _lokasi = '';
  String _harga = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('http://192.168.53.185:5000/api/v1/kuliner/create'),
        body: {
          'nama_kuliner': _namaKuliner,
          'kategori': _kategori,
          'lokasi': _lokasi,
          'harga': _harga,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dibuat')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Kuliner'),
         backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Kuliner',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Kuliner wajib diisi';
                  }
                  return null;
                },
                onSaved: (value) {
                  _namaKuliner = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _kategori,
                items: const [
                  DropdownMenuItem(
                      value: 'Tradisional', child: Text('Tradisional Food')),
                  DropdownMenuItem(
                      value: 'AsianFood', child: Text('Asian Food')),
                  DropdownMenuItem(
                      value: 'WesternFood', child: Text('Western Food')),
                  DropdownMenuItem(
                      value: 'StreetFood', child: Text('Street Food')),
                  DropdownMenuItem(
                      value: 'VeganFood', child: Text('Vegan Food')),
                  DropdownMenuItem(value: 'Dessert', child: Text('Dessert')),
                ],
                onChanged: (value) {
                  setState(() {
                    _kategori = value!;
                  });
                },
                onSaved: (value) {
                  _kategori = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi wajib diisi';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lokasi = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
                onSaved: (value) {
                  _harga = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
