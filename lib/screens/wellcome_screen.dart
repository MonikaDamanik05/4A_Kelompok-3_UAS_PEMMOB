// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/authentication/login_screen.dart';
import 'package:my_app/screens/config_screen.dart';
import 'package:my_app/screens/signup_screen.dart';

class WellcomeScreen extends StatefulWidget {
  const WellcomeScreen({Key? key}) : super(key: key);

  @override
  _WellcomeScreenState createState() => _WellcomeScreenState();
}

class _WellcomeScreenState extends State<WellcomeScreen> {
  Color signUpButtonColor = Colors.orange;
  Color loginButtonColor = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/images/bakso.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: Card(
                color: Colors.black.withOpacity(0.3),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Cari tempat jajan, sekarang!",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    signUpButtonColor, // Warna latar belakang tombol
                                minimumSize: const Size(
                                    double.infinity, 50), // Warna teks tombol
                              ),
                              onPressed: () {
                                setState(() {
                                  signUpButtonColor = Colors
                                      .grey; // Mengubah warna tombol saat ditekan
                                  loginButtonColor =
                                      Colors.orange; // Reset warna tombol Login
                                });
                                // Navigasi ke halaman SignUpScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()),
                                ).then((value) {
                                  setState(() {
                                    signUpButtonColor = Colors.orange;
                                  });
                                });
                              },
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.montserrat(fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color:
                                        loginButtonColor), // Warna garis pinggir tombol
                                minimumSize: const Size(
                                    double.infinity, 50), // Ukuran tombol
                              ),
                              onPressed: () {
                                setState(() {
                                  loginButtonColor = Colors
                                      .orange; // Mengubah warna tombol saat ditekan
                                  signUpButtonColor = Colors
                                      .orange; // Reset warna tombol Sign Up
                                });
                                // Navigasi ke halaman LoginScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                ).then((value) {
                                  // Reset warna tombol setelah kembali dari LoginScreen
                                  setState(() {
                                    loginButtonColor = Colors.orange;
                                  });
                                });
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    color:
                                        loginButtonColor), // Warna teks tombol
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        "Untuk menikmati semua fitur kami, Anda perlu terhubung terlebih dahulu",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 60, // Sesuaikan dengan posisi yang diinginkan dari atas
              left: 20, // Sesuaikan dengan posisi yang diinginkan dari kiri
              child: GestureDetector(
                onTap: () {
                  // Navigasi ke halaman ConfigScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color:
                        Colors.black.withOpacity(0.5), // Warna latar belakang
                    borderRadius:
                        BorderRadius.circular(15), // Mengatur sudut kotak
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.link,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
