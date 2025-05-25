import 'dart:convert';
import 'package:bookly12/VentanaInicio/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class VistaPerfil extends StatefulWidget {
  @override
  State<VistaPerfil> createState() => _VistaPerfilState();
}

class _VistaPerfilState extends State<VistaPerfil> {
  String? nombre;
  String? correo;
  String? fotoURL;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatosDesdeRealtimeDatabase();
  }

  //funcion para cargar los datos de perfil de RealtimeDatabase
  Future<void> cargarDatosDesdeRealtimeDatabase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final idToken = await user.getIdToken();
    final url = Uri.parse(
      'https://bookly-6db9d-default-rtdb.firebaseio.com/users/$uid/profile.json?auth=$idToken',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nombre = data['nombre'];
          correo = data['correo'];
          fotoURL = data['fotoURL'];
          cargando = false;
        });
      } else {
        print("Error al obtener perfil: ${response.statusCode}");
      }
    } catch (e) {
      print("Excepción al obtener perfil: $e");
    }
  }

    //Funcion para cerrar sesion con google y firebase
  void cerrarSesion() async {
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      await FirebaseAuth.instance.signOut();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9DBE9F),
        title: Text(
          "Mi Perfil",
          style: TextStyle(color: Color.fromARGB(255, 31, 28, 28)),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: fotoURL == null ? Colors.grey[300] : Colors.transparent,
                            backgroundImage: fotoURL != null ? NetworkImage(fotoURL!) : null,
                            child: fotoURL == null
                                ? Icon(Icons.person, size: 60, color: Colors.grey[700])
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    //me muestra los datos del perfil del  del usario logueado
                    Text(
                      'Bienvenid@ ${nombre ?? 'Nombre no disponible'}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      correo ?? 'Correo no disponible',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                
                    SizedBox(height: 10),
                    Container(
                      height: 1.2,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 160, 162, 163).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    SizedBox(height: 135),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: cerrarSesion,
                        icon: Icon(Icons.logout),
                        label: Text("Cerrar sesión"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
