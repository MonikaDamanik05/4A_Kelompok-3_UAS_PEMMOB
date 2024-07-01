import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/authentication/login_screen.dart';
import 'package:my_app/cubit/auth_cubit.dart';
import 'package:my_app/cubit/data_login_cubit.dart';
import 'package:my_app/screens/Myhomepage_user.dart';
import 'package:my_app/screens/adminscreen/myhomepage_admin.dart';
import 'package:my_app/screens/signup_screen.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'package:my_app/screens/wellcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<DataLoginCubit>(create: (context) => DataLoginCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const SplashScreenPage(),
        routes: {
          '/masuk-screen': (context) => const WellcomeScreen(),
          '/login-screen': (context) => const LoginScreen(),
          '/daftar-screen': (context) => const SignUpScreen(),
          '/beranda-screen': (context) => const MyHomePage(),
          '/home': (context) => const MyHomePage(),
          '/admin': (context) => const MyHomePageAdmin(),
        },
      ),
    );
  }
}
