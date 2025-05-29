// /lib/VentanaInicio/splash_screen.dart

import 'package:bookly12/VentanaInicio/home.dart';
import 'package:bookly12/VentanaInicio/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Redirigir después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      if (user != null) {
        // Usuario ya logueado
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // No hay sesión activa
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginWithGoogle()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/google_logo.png', width: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}


