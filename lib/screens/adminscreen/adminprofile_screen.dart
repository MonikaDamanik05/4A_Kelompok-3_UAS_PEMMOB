import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/data_login_cubit.dart';
import 'package:my_app/dto/profil.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/wellcome_screen.dart';
import 'package:my_app/services/data_service.dart';

class ProfileScreenAdmin extends StatefulWidget {
  const ProfileScreenAdmin({super.key});

  @override
  ProfileScreenAdminState createState() => ProfileScreenAdminState();
}

class ProfileScreenAdminState extends State<ProfileScreenAdmin> {
  bool isLoading = true;
  Profile? userData;
  String errorMessage = '';
  File? _imageFile;
  final DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;
    int idUser = currentState.idUser;

    try {
      userData = await DataService.fetchUserData(idUser);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    final profile = context.read<DataLoginCubit>();
    final currentState = profile.state;
    int idUser = currentState.idUser;

    if (_imageFile == null) return;

    try {
      await DataService.uploadImage(idUser, _imageFile!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil diunggah')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const WellcomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Pilih Sumber Gambar'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _pickImage(ImageSource.gallery);
                                      },
                                      child: const Text('Galeri'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _pickImage(ImageSource.camera);
                                      },
                                      child: const Text('Kamera'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              _imageFile == null
                                  ? (userData?.foto != null
                                      ? ClipOval(
                                          child: Image.network(
                                            '${Endpoints.getUserPhoto}/${userData!.idUser}',
                                            width: 160, // Updated size
                                            height: 160, // Updated size
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                size: 140, // Updated size
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 80, // Updated size
                                          backgroundColor: Colors.purple,
                                          child: Icon(
                                            Icons.person,
                                            size: 100, // Updated size
                                            color: Colors.white,
                                          ),
                                        ))
                                  : ClipOval(
                                      child: Image.file(
                                        _imageFile!,
                                        width: 260, // Updated size
                                        height: 360, // Updated size
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.indigoAccent,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData?.username ?? '-',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black), // Updated size
                        ),
                        const SizedBox(height: 30),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          color: Colors.white.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileItem(Icons.person_outline,
                                    'Nama Lengkap', userData?.namaLengkap),
                                _buildProfileItem(
                                    Icons.email, 'Email', userData?.email),
                                _buildProfileItem(
                                    Icons.home, 'Alamat', userData?.alamat),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            onPressed: _showLogoutDialog,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.indigoAccent,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 10,
                            ),
                            child: const Text('Logout',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: Colors.indigoAccent, size: 30), // Increased icon size
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18), // Increased text size
              ),
              const SizedBox(height: 5),
              Text(
                value ?? '-',
                style: const TextStyle(fontSize: 18), // Increased text size
              ),
            ],
          ),
        ],
      ),
    );
  }
}
