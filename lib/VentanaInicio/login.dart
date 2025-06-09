import 'package:BOOKLY/VentanaInicio/home.dart';
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

    final url = Uri.parse(
      'https://bookly-6db9d-default-rtdb.firebaseio.com/users/$uid/profile.json?auth=$idToken',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data == null) {
        final perfilData = {
          'nombre': usuario.displayName ?? '',
          'correo': usuario.email ?? '',
          'fotoURL': '',
        };

        final putResponse = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(perfilData),
        );

        if (putResponse.statusCode != 200) {
          throw Exception('Error al crear el perfil en Realtime Database');
        }
      } else {
        print('Perfil ya existe, se conserva la foto.');
      }
    } else {
      throw Exception('Error al verificar el perfil en Realtime Database');
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

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

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
        builder:
            (_) => AlertDialog(
              title: const Text("Error"),
              content: Text("Error al iniciar sesión con Google: $e"),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF737B64),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto "BOOKLY"
              Text(
                "BOOKLY",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40), // Espacio entre el texto y el botón
              // Botón "Iniciar con Google"
              ElevatedButton(
                onPressed: iniciarSesionGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Fondo blanco
                  foregroundColor: Colors.black, // Texto negro
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logotipo de Google
                    Image.asset(
                      'assets/google_logo.png', // Reemplaza con la ruta correcta del archivo
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 10,
                    ), // Espacio entre el logotipo y el texto
                    // Texto "Iniciar con Google"
                    Text(
                      "Iniciar con Google",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
