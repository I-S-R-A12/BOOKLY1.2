import 'dart:convert';

import 'package:BOOKLY/VentanaInicio/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

import 'servicio_cloudinary.dart';  

class vistaPerfil extends StatefulWidget {
  @override
  State<vistaPerfil> createState() => _vistaPerfilState();
}

class _vistaPerfilState extends State<vistaPerfil> {
  String? nombre;
  String? correo;
  String? fotoURL;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatosDesdeRealtimeDatabase();
  }

    // Obtiene los datos del usuario actual(nombre, correo, fotoPerfil)
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
        setState(() {
          cargando = false;
        });
      }
    } catch (e) {
      print("Excepción al obtener perfil: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  //Cierra la sesión del usuario, también cierra sesión de Google 
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

  // se llama  a la función del servicio Cloudinary
  Future<void> seleccionarYSubirImagen() async {
    setState(() {
      cargando = true;
    });

    try {
      final urlImagenCloud = await SubirArchivosACloudinary.seleccionarYSubirImagen();

      if (urlImagenCloud != null) {
        setState(() {
          fotoURL = urlImagenCloud;
          cargando = false;
        });

        await actualizarFotoPerfilEnRealtimeDatabase(urlImagenCloud);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Se actualizó correctamente')),
        );
      } else {
        setState(() {
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
    }
  }

    // selecciona una imagen desde la galería, la sube a Cloudinary y luego actualiza la URL en Firebase
  Future<void> actualizarFotoPerfilEnRealtimeDatabase(String urlFoto) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final idToken = await user.getIdToken();
    final url = Uri.parse(
      'https://bookly-6db9d-default-rtdb.firebaseio.com/users/$uid/profile.json?auth=$idToken',
    );

    try {
      final response = await http.patch(
        url,
        body: json.encode({'fotoURL': urlFoto}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Foto de perfil actualizada en la base de datos');
      } else {
        print('Error al actualizar foto: ${response.statusCode}');
      }
    } catch (e) {
        print('Excepción al actualizar foto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF737B64),
      appBar: AppBar(
        backgroundColor: const Color(0xFF737B64),
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
          child: Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(

                color: Color(0x1AD9D9D9),
                borderRadius: BorderRadius.circular(40), 
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: seleccionarYSubirImagen,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color.fromARGB(255, 219, 211, 211),
                          backgroundImage:
                              (fotoURL != null) ? NetworkImage(fotoURL!) : null,
                          child: (fotoURL == null)
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bienvenid@ ${nombre ?? 'Nombre no disponible'}',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
                  ),
                  // Text(
                    //   correo ?? 'Correo no disponible',
                    //   style: TextStyle(color: Colors.grey[600]),
                    // ),
                  SizedBox(height: 135),
                  ElevatedButton.icon(
                    onPressed: cerrarSesion,
                    icon: Icon(LineIcons.alternateSignOut, color: Colors.black),
                    label: Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD9D9D9),
                      padding:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

