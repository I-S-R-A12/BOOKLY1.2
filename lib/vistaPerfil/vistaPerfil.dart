
import 'package:bookly12/VentanaInicio/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class VistaPerfil extends StatefulWidget {
  @override
  State<VistaPerfil> createState() => _VistaPerfilState();
}
class _VistaPerfilState extends State<VistaPerfil> {

  //metodo para cerrar sesion
    void cerrarSesion() async {
  try {
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    await FirebaseAuth.instance.signOut();

    // Redirige al login
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginWithGoogle()),
      );
    }
  } catch (e) {
    print("Error al cerrar sesión: $e");
    
  }
}

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9DBE9F),
        title: Text(
          "Mi Perfil",
          style: TextStyle(color: const Color.fromARGB(255, 31, 28, 28)),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    //muetra la foto de perfil del usuario que esta autenticado con google
                  CircleAvatar(
                radius: 60,
                backgroundColor: user?.photoURL == null ? Colors.grey[300] : Colors.transparent,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[700],
                      )
                    : null,
              ),

                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //muestra el nombre, que se obteien de auth de google
              Text(
                'Bienvenid@ ${user?.displayName ?? 'Nombre no disponible'}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),

              //muestre el correo del usuario, que se obtiene de auth de google
              Text(
                user?.email ?? 'Correo no disponible',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1.2,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 160, 162, 163).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  SizedBox(height: 135),

                  //icono para cerrar sesion
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: cerrarSesion,
                      icon: Icon(Icons.logout),
                      label: Text("Cerrar sesión"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300],
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
