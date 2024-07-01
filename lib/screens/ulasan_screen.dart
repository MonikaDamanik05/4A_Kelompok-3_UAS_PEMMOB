// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/data_login_cubit.dart';
import 'package:my_app/services/data_service.dart';

class UlasanScreen extends StatefulWidget {
  final int kulinerId;

  const UlasanScreen({super.key, required this.kulinerId});

  @override
  _UlasanScreenState createState() => _UlasanScreenState();
}

class _UlasanScreenState extends State<UlasanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String _bintang = '0';

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = context.read<DataLoginCubit>();
      final currentState = profile.state;
      final idUser = currentState.idUser;

      if (_bintang != '0') {
        try {
          String deskripsi = _descriptionController.text;
          int idKuliner = widget.kulinerId; // No need to parse, already int
          await DataService.createKomentar(
            idKuliner,
            idUser,
            deskripsi,
            _bintang,
          );

          setState(() {
            _descriptionController.clear();
            _bintang = '0';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ulasan berhasil ditambahkan'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambahkan ulasan: ${e.toString()}'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih rating'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tambah Ulasan Produk'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID Kuliner: ${widget.kulinerId}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan deskripsi produk di sini',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan deskripsi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Rating: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...List.generate(
                    5,
                    (index) => IconButton(
                      icon: Icon(
                        index < int.parse(_bintang)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          _bintang = (index + 1).toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                ),
                onPressed: _submitForm,
                child: const Text('Tambahkan Ulasan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
