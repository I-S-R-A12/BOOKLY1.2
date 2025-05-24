//En esta parte puedes empezar ha realizar la ventana de inicio
// Otro comentari
import 'package:bookly12/VentanaInicio/home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
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
      appBar: AppBar(title: const Text("Iniciar sesión con Google")),
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
