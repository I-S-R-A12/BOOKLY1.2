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

// Trackeo en tiempo real
/*
// /lib/VentanaInicio/splash_screen.dart

import 'package:bookly12/VentanaInicio/home.dart';
import 'package:bookly12/VentanaInicio/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Usuario autenticado → navegar a Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // No hay sesión activa → navegar a Login
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
            // Puedes poner un logo aquí si lo tienes
            Image.asset('assets/google_logo.png', width: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
*/
