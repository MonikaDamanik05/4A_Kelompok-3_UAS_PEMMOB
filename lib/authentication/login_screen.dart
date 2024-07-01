// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/my_button.dart';
import 'package:my_app/cubit/auth_cubit.dart';
import 'package:my_app/cubit/data_login_cubit.dart';
import 'package:my_app/dto/login.dart';
import 'package:my_app/services/data_service.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _loginFailed = false;
  final formkey = GlobalKey<FormState>();

  void sendLogin(BuildContext context, AuthCubit authCubit,
      DataLoginCubit dataLogin) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await DataService.sendLoginData(email, password);
      if (response.statusCode == 200) {
        debugPrint("sending success");
        final data = jsonDecode(response.body);
        final loggedIn = Login.fromJson(data);
        await SecureStorageUtil.storage
            .write(key: tokenStoreName, value: loggedIn.accessToken);
        authCubit.login(loggedIn.accessToken);
        getProfile(dataLogin, loggedIn.accessToken, context);
        debugPrint(loggedIn.accessToken);
      } else if (response.statusCode == 401) {
        // Handle login failed due to incorrect credentials
        setState(() {
          _loginFailed = true;
        });
        _showLoginFailedDialog(context);
        debugPrint("Login failed: Incorrect credentials");
      } else {
        // Handle other server errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan pada server. Silakan coba lagi.'),
          ),
        );
        debugPrint("Server error: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan pada server: $e'),
        ),
      );
      debugPrint("Server error: $e");
    }
  }

  void getProfile(
      DataLoginCubit profileCubit, String? accessToken, BuildContext context) {
    if (accessToken == null) {
      debugPrint('Access token is null');
      return;
    }

    DataService.fetchProfile(accessToken).then((profile) {
      debugPrint(profile.toString());
      profileCubit.setProfile(profile.roles, profile.userLogged);
      profileCubit.state.roles == 'admin'
          ? Navigator.pushReplacementNamed(context, '/admin')
          : Navigator.pushReplacementNamed(context, '/home');
    }).catchError((error) {
      debugPrint('Error fetching profile: $error');
    });
  }

  void _showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Email atau password salah. Silakan coba lagi.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final dataLogin = BlocProvider.of<DataLoginCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/mangan_logo.png",
              width: 250,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: _loginFailed
                            ? Colors.red
                            : Colors.black, // Change text color
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _loginFailed
                              ? Colors.red
                              : Colors.black, // Change border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _loginFailed
                              ? Colors.red
                              : Colors.black, // Change border color
                        ),
                      ),
                      errorText: _loginFailed
                          ? 'Silakan masukkan email'
                          : null, // Error message
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: _loginFailed
                            ? Colors.red
                            : Colors.black, // Change text color
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _loginFailed
                              ? Colors.red
                              : Colors.black, // Change border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _loginFailed
                              ? Colors.red
                              : Colors.black, // Change border color
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _loginFailed
                              ? Colors.red
                              : Colors.black, // Change icon color
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      errorText: _loginFailed
                          ? 'Silakan masukkan password'
                          : null, // Error message
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: () {
                      sendLogin(context, authCubit, dataLogin);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
