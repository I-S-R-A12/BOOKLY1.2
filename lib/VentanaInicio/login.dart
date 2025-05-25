
import 'package:bookly12/VentanaInicio/home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  
  // Función para guardar nombre, correo  y url de Fperfil en Realtime Database
  Future<void> guardarPerfilEnRealtimeDatabase(User usuario) async {
    final uid = usuario.uid;
    final idToken = await usuario.getIdToken();

    final url = Uri.parse('https://bookly-6db9d-default-rtdb.firebaseio.com/users/$uid/profile.json?auth=$idToken');

    final perfilData = {
      'nombre': usuario.displayName ?? '',
      'correo': usuario.email ?? '',
     'fotoURL': usuario.photoURL ?? '',
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(perfilData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar perfil en Realtime Database');
    }
  }

  Future<void> iniciarSesionGoogle() async {
    try {
      if (kIsWeb) {
        // Para web: usa signInWithPopup
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(authProvider);
      } else {
        // Para móvil: usa google_sign_in package
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      await FirebaseAuth.instance.currentUser?.reload();

      // Guardar nombre y correo y url de Fperfil en base de datos personalizada
      User? usuario = FirebaseAuth.instance.currentUser;
      if (usuario != null) {
        await guardarPerfilEnRealtimeDatabase(usuario);
      }

      // Navega a la vista principal después de iniciar sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Error al iniciar sesión con Google: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar sesión con Google"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Iniciar sesión con Google"),
          onPressed: iniciarSesionGoogle,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
